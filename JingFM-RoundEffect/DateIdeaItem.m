//
//  DateIdeaItem.m
//  MagicOpener
//
//  Created by wenlin on 14-8-1.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "DateIdeaItem.h"

@implementation DateIdeaItem

-(instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName{
    
    
    self = [super init];
    
    if (self) {
        _title = title;
        _imageName = imageName;
    }
    return self;
}

@end
