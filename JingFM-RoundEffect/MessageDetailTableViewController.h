//
//  MessageDetailTableViewController.h
//  MagicOpener
//
//  Created by wenlin on 14-5-29.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import <ASMediaFocusManager.h>

@interface MessageDetailTableViewController : UITableViewController<UITableViewDelegate,StarRatingViewDelegate,ASMediasFocusDelegate>


@property (nonatomic,strong) PFObject *message;

@end
