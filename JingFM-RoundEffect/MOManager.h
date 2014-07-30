//
//  MOManager.h
//  MagicOpener
//
//  Created by wenlin on 14-7-30.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAPI.h"

@interface MOManager : NSObject

@property (readonly,nonatomic) DPAPI *dpApi;

+ (instancetype)sharedManager;

@end
