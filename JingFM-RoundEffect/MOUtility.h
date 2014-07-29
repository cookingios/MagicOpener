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

//根据图像识别结果,返回提示内容
+ (NSString *)getHintFromResult:(NSDictionary *)result;

//返回图像
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//Bolts
+ (BFTask *)findAsync:(PFQuery *)query;

//Unicode 转为 UTF-8
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;



@end
