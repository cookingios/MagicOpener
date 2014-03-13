//
//  MenuViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-23.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+RESideMenu.h"


@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

@end

@implementation MenuViewController

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
    self.sideMenuViewController.parallaxEnabled = NO;
    self.sideMenuViewController.contentViewScaleValue = 0.7f;
    self.sideMenuViewController.panFromEdge = YES;
    //self.sideMenuViewController.contentViewInLandscapeOffsetCenterX = CGRectGetHeight(self.view.frame) + 30.f;
    self.sideMenuViewController.delegate = self;

}

- (void)configUnreadMessageLabel{
    
    UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentMessageViewController)];
    [self.messageImageView addGestureRecognizer:messageTap];
    
    self.messageCountLabel.layer.cornerRadius = 5.0f;
    self.messageCountLabel.layer.masksToBounds = YES;
    
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
        [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
        [query whereKey:@"status" equalTo:@0];
        [query whereKey:@"type" equalTo:@"comment"];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                NSNumber *number = [NSNumber numberWithInt:count];
                NSLog(@"get count %@",number);
                if (number.integerValue > 0) {
                    self.messageCountLabel.hidden = NO;
                    self.messageCountLabel.text = [NSString stringWithFormat:@"%@",number];
                }else self.messageCountLabel.hidden = YES;
                
            } else {
                // The request failed
                //self.unreadMessageCount = @0;
                self.messageCountLabel.hidden = YES;
                NSLog(@"get error by unread count %@",error);
            }
        }];
    }
        

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    id dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    switch (indexPath.row) {
        case 0:
            //[dvc setValue:@"clue" forKey:@"eventType"];
            navigationController.viewControllers = @[dvc];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [dvc setValue:@"lost" forKey:@"eventType"];
            navigationController.viewControllers = @[dvc];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            [dvc setValue:@"adopt" forKey:@"eventType"];
            navigationController.viewControllers = @[dvc];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;

            
        default:
            break;
    }
}

- (void)presentMessageViewController{
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"]];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController{

    [self configUnreadMessageLabel];
    
}
@end
