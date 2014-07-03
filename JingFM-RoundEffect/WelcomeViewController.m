//
//  WelcomeViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-22.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "WelcomeViewController.h"


@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation WelcomeViewController

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
    self.backgroundImageView.dataSource = self;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.layer.masksToBounds = YES;
    self.signupButton.layer.cornerRadius = 3.0f;
    self.signupButton.layer.masksToBounds = YES;
    [TSMessage setDefaultViewController:self.navigationController.topViewController];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Welcome"];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"Welcome"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSAnimatedImagesViewDataSource Methods

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return 2;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"login-%ld.png", (long)(index + 1)]];
}


- (IBAction)signup:(id)sender {
    NSLog(@"signup debug1");
    [self performSegueWithIdentifier:@"SignUp" sender:self];
    NSLog(@"signup debug2");
}

- (IBAction)login:(id)sender {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
@end
