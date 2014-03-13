//
//  OpenerView.h
//  MagicOpener
//
//  Created by wenlin on 14-2-28.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenerView : UIView
@property (weak, nonatomic) IBOutlet UITextView *openerTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIButton *freeChanceButton;


@end

