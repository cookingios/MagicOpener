//
//  MOExpert.h
//  MagicOpener
//
//  Created by wenlin on 14-7-25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOExpert : NSObject

@property NSString *userId;
@property NSString *name;
@property UIImage *avatarImage;
@property NSString *description;

-(instancetype)initWithUserId:(NSString*) idnum name:(NSString*)name avatar:(UIImage*) avatarImage description:(NSString*) description;

@end
