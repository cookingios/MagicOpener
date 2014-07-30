//
//  MOManager.m
//  MagicOpener
//
//  Created by wenlin on 14-7-30.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "MOManager.h"

@implementation MOManager

+ (instancetype)sharedManager {
    
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
	self = [super init];
    if (self) {
        
        _dpApi = [[DPAPI alloc] init];
        
    }
    return self;
}



@end
