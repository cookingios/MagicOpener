//
//  ArticleDetailViewController.h
//  MagicOpener
//
//  Created by wenlin on 14-5-24.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTemplateEngine.h"
#import "AGViewDelegate.h"
#import "AppDelegate.h"

@interface ArticleDetailViewController : UIViewController<MGTemplateEngineDelegate,UIWebViewDelegate,UIActionSheetDelegate>{
    
    
    AppDelegate *_appDelegate;
}

@end
