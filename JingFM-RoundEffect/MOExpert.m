//
//  MOExpert.m
//  MagicOpener
//
//  Created by wenlin on 14-7-25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "MOExpert.h"

@implementation MOExpert

-(instancetype)initWithUserId:(NSString*) idnum name:(NSString*)name avatar:(UIImage*) avatarImage description:(NSString*) description{
    
   self = [super init];
    _userId = idnum;
    _name = name;
    _avatarImage = avatarImage;
    _description = description;
    
    return self;
    
}


@end
