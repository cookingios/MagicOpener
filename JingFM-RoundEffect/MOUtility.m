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
