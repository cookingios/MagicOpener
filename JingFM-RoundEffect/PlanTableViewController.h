//
//  PlanTableViewController.h
//  MagicOpener
//
//  Created by wenlin on 14-7-31.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanTableViewController : UITableViewController

@property (strong,nonatomic) NSDictionary *planDataSource;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;

@end
