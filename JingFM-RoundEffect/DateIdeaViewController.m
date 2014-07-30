//
//  DateIdeaViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-7-29.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "DateIdeaViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "DPAPI.h"

@interface DateIdeaViewController ()<DPRequestDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *relationshipTypeSegment;
@property (strong,nonatomic) PFGeoPoint *currentGeoPoint;
@property (strong,nonatomic) NSDictionary *currentPlanDataSource;
@property (readonly,nonatomic) DPAPI *dpApi;

- (IBAction)showMenu:(id)sender;
- (IBAction)refreshDatePlan:(id)sender;


@end

@implementation DateIdeaViewController

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
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            self.currentGeoPoint = geoPoint;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取地理位置信息" message:@"请前往设置打开该选项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)refreshDatePlan:(id)sender {
    
    if (!self.currentGeoPoint) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取地理位置信息" message:@"请前往设置打开该选项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        return [alert show];
    }
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentGeoPoint.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentGeoPoint.longitude];
    NSString *paramsString = [NSString stringWithFormat:@"category=美食&sort=4&limit=5&latitude=%@&longitude=%@",latitude,longitude];
    
    [[[MOManager sharedManager] dpApi] requestWithURL:@"v1/business/find_businesses" paramsString:paramsString delegate:self];
}

#pragma mark - dpRequest delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	

    NSLog(@"Error从大众点评返回：%@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
	NSLog(@"成功从大众点评返回：%@",[result description]);
}

@end
