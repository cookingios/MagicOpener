//
//  OpenerView.m
//  MagicOpener
//
//  Created by wenlin on 14-2-28.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "OpenerView.h"

@implementation OpenerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.openerTextView.selectable = YES;
    self.openerTextView.editable = NO;
    self.descriptionTextView.selectable = NO;
    self.descriptionTextView.editable = NO;
 
}



@end
