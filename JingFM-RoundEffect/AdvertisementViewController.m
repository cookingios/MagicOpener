//
//  AdvertisementViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-6-16.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "AdvertisementViewController.h"
#import <RESideMenu.h>


@interface AdvertisementViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *advertWebView;

- (IBAction)showMenu:(id)sender;

@end

@implementation AdvertisementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSURL *url2 = [NSURL URLWithString:@"http://www.baidu.com"];
    NSString *string = (NSString *)[MobClick getAdURL];
    string= [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:string];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_advertWebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    /*
    //NSString *stringURL = (NSString *)[MobClick getAdURL];
    //NSLog(@"%@",stringURL);
    NSURL *url =[NSURL URLWithString:@"http://w.m.taobao.com/api/wap?app_key=5394383a56240b4ed102115a&device_id=C5CE3480-7349-4ED5-BE5B-7CF7C4BC9F52&aid=7024BB51-A091-4166-94C4-68B78367C959&mac=02:00:00:00:00:00&channel=APP Store"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_advertWebView loadRequest:request];
    */
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
    
}
@end
