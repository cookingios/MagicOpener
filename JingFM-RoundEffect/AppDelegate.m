//
//  AppDelegate.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import "AppDelegate.h"
#import "FaceppAPI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"uVNIxVLBvUWvVtLaFhMquaYZR2Tqje84YwcQ63i6"
                  clientKey:@"i28vvdncRQOzvLg7MqC4EYTXOyAChThecuC5D2Dm"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [FaceppAPI initWithApiKey:@"87d3930c16fb8344c92b5ff8112aaf49" andApiSecret:@"GqqSTgSt611FzDN2j1Qh9fbv_Q2kgMh1"
                    andRegion:APIServerRegionCN];
    
    [FaceppAPI setDebugMode:YES];
    /*
    NSData *imageData = UIImageJPEGRepresentation(
                                                  [UIImage imageNamed:@"sample.jpg"], 100);
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil
                                                    orImageData:imageData];
    */

    // Override point for customization after application launch.
    
    [PFPurchase addObserverForProduct:@"1YearProVersion" block:^(SKPaymentTransaction *transaction) {
        [[PFUser currentUser] setObject:@"1YearProVersion" forKey:@"type"];
        [[PFUser currentUser] saveInBackground];
    }];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
