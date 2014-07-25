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

@property (strong,nonatomic) NSString *toUserId;


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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Helper"];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Helper"];
    
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
    
    switch (indexPath.row) {
        case 0:
            self.toUserId = @"zlUNHVRCEX";
            break;
        case 1:
            self.toUserId = @"ZTLhLSzDf2";
            break;
        case 2:
            self.toUserId = @"DrIepaI8DF";
            break;
            
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"SelectQuestionTypeSegue" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id dvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SelectQuestionTypeSegue"]) {
        [dvc setValue:self.toUserId forKey:@"toUserId"];
    }
}


@end
