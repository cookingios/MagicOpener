//
//  AppDelegate.h
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewDelegate.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
    {
        enum WXScene _scene;
        AGViewDelegate *_viewDelegate;
    }


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AGViewDelegate *viewDelegate;

@end
