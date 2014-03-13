//
//  DateProblemViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-11-5.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "DateProblemViewController.h"

@interface DateProblemViewController (){
    
    MBProgressHUD *hud;
    
}
@property (weak, nonatomic) IBOutlet UITextView *problemTextView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


- (IBAction)submit:(id)sender;

@end

@implementation DateProblemViewController

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
    _emailLabel.text = [[PFUser currentUser] objectForKey:@"email"];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _submitButton.layer.cornerRadius = 5.0;
    _submitButton.layer.masksToBounds = YES;
    
    [_problemTextView becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    NSString * problem = [MOUtility trimString:_problemTextView.text];
    
    if (problem.length >0) {
        
        //hud & Timer
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        [hud show:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
        
        
        PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
        [feedback setObject:@1 forKey:@"questionId"];
        [feedback setObject:problem forKey:@"dateProblem"];
        [feedback setObject:[PFUser currentUser] forKey:@"fromUser"];
        [feedback setObject:[[PFUser currentUser] objectForKey:@"email"] forKey:@"email"];
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [timer invalidate];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"成功提交";
                [hud hide:YES afterDelay:2];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"网络连接问题,请稍后再试"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
                
            }
        }];
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"问题内容为空"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    }
}


- (void)handleHudTimeout{
    
    hud.mode = MBProgressHUDModeText;
	hud.labelText = @"网络连接有问题";
    [hud hide:YES afterDelay:3];
}
@end
