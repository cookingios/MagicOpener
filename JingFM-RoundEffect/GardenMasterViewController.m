//
//  GardenMasterViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-10-25.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "GardenMasterViewController.h"

@interface GardenMasterViewController ()
- (IBAction)dismissViewController:(id)sender;

@end

@implementation GardenMasterViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [self logoutBtnPress:self];
    }
    
    
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
#pragma mark - 返回
- (IBAction)dismissViewController:(id)sender {
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - 退出登录
-(IBAction)logoutBtnPress:(id)sender{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (!buttonIndex) {
        [PFUser logOut];
        [self performSegueWithIdentifier:@"OpenerSegue" sender:self];
    }
}

@end
