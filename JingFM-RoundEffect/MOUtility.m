//
//  MOUtility.m
//  MagicOpener
//
//  Created by wenlin on 13-8-11.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "MOUtility.h"


@implementation MOUtility

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
    
}

+ (BOOL)stringIsEmpty: (NSString *)string {
    if (string == nil || [string length] == 0) {
        return TRUE;
    }
    return FALSE;
}


+ (NSString *)trimString:(NSString *)imputText{
    
	NSString *trimmedComment = [imputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return trimmedComment;
	
}

+ (NSString *)getImageNameByRate:(NSNumber *)rate {
    
    NSString *string = @"";
    if (rate) {
        switch ([rate intValue]) {
            case 1:
                string = @"1star";
                break;
            case 2:
                string = @"2star";
                break;
            case 3:
                string = @"3star";
                break;
            case 4:
                string = @"4star";
                break;
            case 5:
                string = @"5star";
                break;
                
            default:
                break;
        }
    }else{
        string = @"0star";
    }
    
    return string;
}


+ (NSString *)getHintFromResult:(NSDictionary *)result{
    
    NSString *hint = @"解析错误";
    NSArray *faces = result[@"face"];
    if ([faces count]==0) {
        return @"没有发现人类";
    }
    
    if ([faces count] > 1) {
        return @"不允许3p或以上";
    }
    
    return hint;
}

+ (BFTask *)findAsync:(PFQuery *)query{
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [task setResult:objects];
            
        } else {
            NSLog(@"inside error is %@",error);
            [task setError:error];
            
        }
    }];
    
    return task.task;
}


@end
