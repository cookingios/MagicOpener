//
//  MOBusiness.m
//  MagicOpener
//
//  Created by wenlin on 14-7-31.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "MOBusiness.h"

@implementation MOBusiness

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"businessId": @"business_id",
             @"branch": @"branch_name",
             @"avgPrice": @"avg_price",
             @"url": @"business_url"
             };
}


@end
