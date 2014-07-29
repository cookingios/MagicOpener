//
//  SelectQuestionTypeTableViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-7-25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "SelectQuestionTypeTableViewController.h"

@interface SelectQuestionTypeTableViewController ()

@property (strong,nonatomic) NSString *toUserId;
@property (strong,nonatomic) NSString *type;


@end

@implementation SelectQuestionTypeTableViewController

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
    
    NSLog(@"id is %@",self.toUserId);
    
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
    
    switch (indexPath.row) {
        case 0:
            self.type = @"chat";
            break;
        case 1:
            self.type = @"image";
            break;
        case 2:
            self.type = @"love";
            break;
            
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"SubmitSegue" sender:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id dvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SubmitSegue"]) {
        
        [dvc setValue:self.toUserId forKey:@"toUserId"];
        [dvc setValue:self.type forKey:@"type"];
    
    }

}
@end
