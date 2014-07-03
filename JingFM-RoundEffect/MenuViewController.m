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


@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *advertLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *advertCell;

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
    
    self.messageCountLabel.layer.cornerRadius = 5.0f;
    self.messageCountLabel.layer.masksToBounds = YES;
    
    PFUser *user = [PFUser currentUser];
    BOOL isExpert = [[user objectForKey:@"isExpert"] boolValue];
    
    
    //专家用户
    if (user && isExpert) {
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"expert" equalTo:[PFUser currentUser]];
        [query whereKey:@"isReplyed" equalTo:[NSNumber numberWithBool:NO]];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                NSNumber *number = [NSNumber numberWithInt:count];
                NSLog(@"get unread count %@",number);
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
    //普通用户
    }else if(user && (!isExpert)){
        
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"isReplyed" equalTo:[NSNumber numberWithBool:YES]];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query whereKey:@"isRead" equalTo:[NSNumber numberWithBool:NO]];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                NSNumber *number = [NSNumber numberWithInt:count];
                NSLog(@"get unread count %@",number);
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

- (void)configAdvertisementLabel{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if ([[object objectForKey:@"isShowedAdvert"] isEqualToNumber:@1]) {
                self.advertCell.hidden = NO;
            }
        }
    }];

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
            navigationController.viewControllers = @[dvc];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"SelectMyExpertViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
            /*
        case 6:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"AdvertisementViewController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
             */

            
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
    //[self configAdvertisementLabel];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
@end
