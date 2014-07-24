//
//  ViewController.h
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#import <UIKit/UIKit.h>
#import "JingRoundView.h"
#import <MBProgressHUD.h>


@interface ViewController : UIViewController<JingRoundViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) IBOutlet JingRoundView *roundView;


@end
