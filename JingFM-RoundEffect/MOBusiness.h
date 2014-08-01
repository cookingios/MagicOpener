//
//  MOBusiness.h
//  MagicOpener
//
//  Created by wenlin on 14-7-31.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface MOBusiness : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *businessId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *branch;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSArray *categories;
@property (nonatomic,strong) NSNumber *avgPrice;
@property (nonatomic,strong) NSString *url;

@end
