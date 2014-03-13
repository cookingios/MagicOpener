//
//  MOUtility.h
//  MagicOpener
//
//  Created by wenlin on 13-8-11.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts.h>

@interface MOUtility : NSObject

//日期转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date;

//字符串是否为空
+ (BOOL)stringIsEmpty: (NSString *)string;

//去除字符串空格
+ (NSString *)trimString:(NSString *)imputText;

//获取星星图片名称
+ (NSString *)getImageNameByRate:(NSNumber *)rate;

//Bolts
+ (BFTask *)findAsync:(PFQuery *)query;

@end
