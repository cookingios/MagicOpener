//
//  DateIdeaItem.h
//  MagicOpener
//
//  Created by wenlin on 14-8-1.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateIdeaItem : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *imageName;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *description;

-(instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName content:(NSString*)content;

@end
