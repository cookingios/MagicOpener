//
//  SignUpViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-7-28.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet BZGFormField *emailTextField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordTextField;

@property (unsafe_unretained,nonatomic) BOOL isEditing;


- (IBAction)validateSignUpInfo:(id)sender;

@end

@implementation SignUpViewController


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
    NSLog(@"signup debug3");
    [self configSignUpTextField];
    NSLog(@"signup debug4");
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.isEditing = NO;
    [TSMessage setDefaultViewController:self.navigationController];
    self.backgroundScrollView.contentSize = CGSizeMake(320, 520);
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [TSMessage dismissActiveNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - config textfield
- (void)configSignUpTextField{
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
	// Do any additional setup after loading the view.
    self.emailTextField.textField.placeholder = @"注册邮箱";
    self.emailTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    __weak SignUpViewController *weakSelf = self;
    [self.emailTextField setTextValidationBlock:^BOOL(NSString *text) {
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
    [self.emailTextField setAsyncTextValidationBlock:^BOOL(NSString *text) {
        NSString *trimText = [MOUtility trimString:text];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:trimText];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        NSInteger k = [query countObjects];
        //NSLog(@"%d",k);
        if (k>0) {
            weakSelf.emailTextField.alertView.title = @"该邮箱已注册,请返回登录";
            return NO;
        }
        return YES;
    }];
    
    self.passwordTextField.textField.placeholder = @"设置密码";
    self.passwordTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.textField.secureTextEntry = YES;
    [self.passwordTextField setTextValidationBlock:^BOOL(NSString *text) {
        NSString *trimText = [MOUtility trimString:text];
        if (trimText.length < 8) {
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

#pragma mark - validate signup info
- (IBAction)validateSignUpInfo:(id)sender {
    
    [self.view endEditing:YES];
    NSString *error = @"";
    
    if (self.emailTextField.formFieldState != BZGFormFieldStateValid) {
        error = @"请检查注册邮箱";
        [self.emailTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    if (self.passwordTextField.formFieldState != BZGFormFieldStateValid) {
        error = @"请检查密码设置";
        [self.passwordTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }

    
    [MRProgressOverlayView showOverlayAddedTo:[[self view] window] title:@"稍等片刻 ..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.textField.text;
    user.password = self.passwordTextField.textField.text;
    user.email = self.emailTextField.textField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

