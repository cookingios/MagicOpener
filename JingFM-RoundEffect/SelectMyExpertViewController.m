//
//  SelectMyExpertViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-3-15.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "SelectMyExpertViewController.h"
#import <RESideMenu.h>

@interface SelectMyExpertViewController ()

@property (strong,nonatomic) PFUser *toUser;


- (IBAction)showMenu:(id)sender;

@end

@implementation SelectMyExpertViewController

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


- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PFQuery *query = [PFUser query];
    
    switch (indexPath.row) {
        case 0:
            self.toUser = (PFUser *)[query getObjectWithId:@"zlUNHVRCEX"];
            break;
        case 1:
            self.toUser = (PFUser *)[query getObjectWithId:@"ZTLhLSzDf2"];
            break;
            
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"SubmitSegue" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id dvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SubmitSegue"]) {
        [dvc setValue:self.toUser forKey:@"toUser"];
    }
}


@end
