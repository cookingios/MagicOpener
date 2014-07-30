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
    
    NSString *hint = @"正在下载开场白";
    NSArray *faces = result[@"face"];
    if ([faces count]==0) {
        return @"没有发现人类";
    }
    
    if ([faces count]>1) {
        return @"太淫荡了,这么多人";
    }
    NSDictionary *gender = [[faces[0] objectForKey:@"attribute"] objectForKey:@"gender"];
    if ([gender[@"value"] isEqualToString:@"Male"]) {
        return @"我们不帮你搭讪男人";
    }
    
    return hint;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    NSString *finalString = [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
    return finalString;
}


+(BFTask*) fetchJsonWithURL:(NSURL*)url{
    NSLog(@"Fetching: %@",url.absoluteString);
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            //TODO:Handle retrieved data
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            NSLog(@"json is %@",[json description]);
            
            if (!jsonError) {
                
                if (![[json allKeys] containsObject:@"error"]) {
                    [task setResult:json];
                }else{
                    NSError *error = [NSError errorWithDomain:nil code:[[json objectForKey:@"code"] intValue] userInfo:json];
                    [task setError:error];
                }
                
                
            }else{
                [task setError:jsonError];
            }
            
        }else{
            
            [task setError:error];
        }
    }];
    
    //执行NSURLSession
    [dataTask resume];
    
    return task.task;
}

@end
