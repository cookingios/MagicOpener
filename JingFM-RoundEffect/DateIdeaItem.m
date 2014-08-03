//
//  DateIdeaItem.m
//  MagicOpener
//
//  Created by wenlin on 14-8-1.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "DateIdeaItem.h"
#import "AutoCoding.h"

@implementation DateIdeaItem

-(instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName content:(NSString*)content{
    
    
    self = [super init];
    
    if (self) {
        _title = title;
        _imageName = imageName;
        _content = content;
    }
    return self;
}

@end
