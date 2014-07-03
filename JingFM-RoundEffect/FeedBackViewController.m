//
//  FeedBackViewController.m
//  WebApp
//
//  Created by wenlin on 14-5-16.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "FeedBackViewController.h"
#import <RESideMenu.h>

@interface FeedBackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

- (IBAction)showMenu:(id)sender;
- (IBAction)submitFeedback:(id)sender;

@end

@implementation FeedBackViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)submitFeedback:(id)sender {
    
    if (_feedbackTextView.text) {
        PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
        [feedback setObject:_feedbackTextView.text forKey:@"feedback"];
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功,感谢你的反馈!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alert show];
                
                _feedbackTextView.text =@"";
            }
            
        }];
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"录入不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}
@end
