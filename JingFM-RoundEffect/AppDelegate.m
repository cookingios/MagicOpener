//
//  AppDelegate.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import "AppDelegate.h"
#import "FaceppAPI.h"
#import <ShareSDK/ShareSDK.h>


@implementation AppDelegate

- (id)init
{
    if(self = [super init])
    {
        _scene = WXSceneSession;
        _viewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MobClick startWithAppkey:@"5394383a56240b4ed102115a" reportPolicy:SEND_INTERVAL   channelId:@"APP Store"];

    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [Parse setApplicationId:@"uVNIxVLBvUWvVtLaFhMquaYZR2Tqje84YwcQ63i6"
                  clientKey:@"i28vvdncRQOzvLg7MqC4EYTXOyAChThecuC5D2Dm"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [FaceppAPI initWithApiKey:@"87d3930c16fb8344c92b5ff8112aaf49" andApiSecret:@"GqqSTgSt611FzDN2j1Qh9fbv_Q2kgMh1"
                    andRegion:APIServerRegionCN];
    
    [FaceppAPI setDebugMode:YES];
    // Override point for customization after application launch.
    
    [PFPurchase addObserverForProduct:@"1YearProVersion" block:^(SKPaymentTransaction *transaction) {
        [[PFUser currentUser] setObject:@"1YearProVersion" forKey:@"type"];
        [[PFUser currentUser] saveInBackground];
    }];
    
    //PUSH Notification
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    /*
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    */
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
    
    [ShareSDK registerApp:@"2b28bf991610"];
    [ShareSDK importWeChatClass:[WXApi class]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (![[PFUser currentUser] objectForKey:@"isExpert"]){
        //user badge 打开即消失
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            [currentInstallation saveEventually];
        }
    }else{
        //expert 的badge一直保留
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"expert" equalTo:[PFUser currentUser]];
        [query whereKey:@"isReplyed" equalTo:[NSNumber numberWithBool:NO]];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                currentInstallation.badge = count;
                [currentInstallation saveEventually];
            }
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - push notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    if ([PFUser currentUser]) {
        [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
    }
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //[[MOManager sharedManager] getUnreadMessageCount];
    
}

#pragma mark - wxapi 
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    
}

@end
