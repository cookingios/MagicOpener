//
//  ExpertMessageDetailTableViewController.h
//  MagicOpener
//
//  Created by wenlin on 14-6-6.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import <ASMediaFocusManager.h>

@interface ExpertMessageDetailTableViewController : UITableViewController<UITableViewDelegate,ASMediasFocusDelegate,UIAlertViewDelegate>


@property (nonatomic,strong) PFObject *message;

@end
