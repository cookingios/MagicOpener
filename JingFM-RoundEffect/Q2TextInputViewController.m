//
//  Q2TextInputViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-10-12.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "Q2TextInputViewController.h"

@interface Q2TextInputViewController (){
    
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *openerTextField;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)saveFeedBack:(id)sender;

@end

@implementation Q2TextInputViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _emailLabel.text = [[PFUser currentUser]objectForKey:@"email"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    _submitButton.layer.cornerRadius = 5.0f;
    _submitButton.layer.masksToBounds = YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveFeedBack:(id)sender {
    

    
    //检验
    if (([[MOUtility trimString:_openerTextField.text] length]>0 ) && ([[MOUtility trimString:_replyTextField.text] length]>0) ) {
        
        //hud & Timer
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        [hud show:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
        
        PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
        [feedback setObject:@2 forKey:@"questionId"];
        [feedback setObject:[MOUtility trimString:_openerTextField.text] forKey:@"opener"];
        [feedback setObject:[MOUtility trimString:_replyTextField.text] forKey:@"reply"];
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是不是哪里漏了输入?再检查下吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
}


@end
