//
//  LoginViewController.m
//  JingFM-RoundEffect
//
//  Created by wenlin on 13-7-25.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet BZGFormField *emailTextField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

@property (unsafe_unretained,nonatomic) BOOL isEditing;

- (IBAction)validateLoginInfo:(id)sender;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configLoginTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LogIn"];
    
    self.navigationController.navigationBarHidden = NO;
    [TSMessage setDefaultViewController:self.navigationController];
    self.backgroundScrollView.contentSize = CGSizeMake(320, 720);
    self.backgroundScrollView.scrollEnabled = YES;
    self.isEditing = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LogIn"];
    
    [TSMessage dismissActiveNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
   // [self.emailTextField.textField becomeFirstResponder];
}
#pragma mark - config textfield
- (void)configLoginTextField{
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
	// Do any additional setup after loading the view.
    self.emailTextField.textField.placeholder = @"邮箱账号";
    self.emailTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.textField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.textField.tag = 180;
    __weak LoginViewController *weakSelf = self;
    [self.emailTextField setTextValidationBlock:^BOOL(BZGFormField *field,NSString *text) {
        NSString *trimText = [MOUtility trimString:text];
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:trimText]) {
            weakSelf.emailTextField.alertView.title = @"邮箱地址格式不正常";
            return NO;
        } else {
            return YES;
        }
    }];
    
    //emailTextField Add online validation
    [self.emailTextField setAsyncTextValidationBlock:^BOOL(BZGFormField *field,NSString *text) {
        NSString *trimText = [MOUtility trimString:text];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:trimText];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        NSInteger k = [query countObjects];
        //NSLog(@"%d",k);
        if (k<1) {
            weakSelf.emailTextField.alertView.title = @"找不到该账号,请尝试注册";
            return NO;
        }
        return YES;
    }];
    
    self.passwordTextField.textField.placeholder = @"密码";
    self.passwordTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.textField.secureTextEntry = YES;
    self.passwordTextField.textField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.textField.tag = 240;
    [self.passwordTextField setTextValidationBlock:^BOOL(BZGFormField *field,NSString *text) {
        NSString *trimText = [MOUtility trimString:text];
        if (trimText.length < 6) {
            weakSelf.passwordTextField.alertView.title = @"密码有点短";
            return NO;
        } else {
            return YES;
        }
    }];
    
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (!self.isEditing) {
        _backgroundScrollView.contentSize = CGSizeMake(320, 680);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _backgroundScrollView.contentOffset=CGPointMake(0, 50);
        } completion:nil];
        
        self.editing = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]){
    	return NO;
    }
    else {
    	return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    switch (textField.tag) {
        case 180:
            [self.passwordTextField.textField becomeFirstResponder];
            break;
        case 240:
            [self validateLoginInfo:textField];
        default:
            break;
    }
    
    return YES;
}


#pragma mark - validate login info
- (IBAction)validateLoginInfo:(id)sender {
    
    [self.view endEditing:YES];
    NSString *error = @"";
    
    if (self.emailTextField.formFieldState != BZGFormFieldStateValid) {
        error = @"请检查登录邮箱账号";
        [self.emailTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    if (self.passwordTextField.formFieldState != BZGFormFieldStateValid) {
        error = @"请检查密码";
        [self.passwordTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    
    [MRProgressOverlayView showOverlayAddedTo:[[self view] window] title:@"稍等片刻" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.textField.text password:self.passwordTextField.textField.text block:^(PFUser *user, NSError *error) {
        [timer invalidate];
        if (!error) {
            //Setup the installation.
            PFInstallation *installation = [PFInstallation currentInstallation];
            [installation setObject:user forKey:@"owner"];
            [installation saveInBackground];
            [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"] animated:NO completion:nil];
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
                [self showErrorMessage:errorString];
            }];
        }
        
    }];
    
}

- (void)handleHudTimeout{
    
    [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
        [TSMessage showNotificationWithTitle:@"网络连接超时,请重试" type:TSMessageNotificationTypeError];
    }];
    
}


- (void)showErrorMessage:(NSString*)message{
    
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
    
}


@end
