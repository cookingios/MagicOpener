//
//  HistoryViewController.h
//  MagicOpener
//
//  Created by wenlin on 14-7-25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//
@class MOExpert;

#import <UIKit/UIKit.h>
#import <SwipeView/SwipeView.h>

@interface HistoryViewController : UIViewController<SwipeViewDataSource,SwipeViewDelegate>

@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) MOExpert *expert;

@end
