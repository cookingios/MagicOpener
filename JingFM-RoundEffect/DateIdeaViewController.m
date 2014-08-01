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
#import "MOBusiness.h"

@interface DateIdeaViewController ()<DPRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *relationshipTypeSegment;
@property (strong,nonatomic) PFGeoPoint *currentGeoPoint;
@property (strong,nonatomic) MOBusiness *currentBusiness;
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
    NSString *paramsString = [NSString stringWithFormat:@"category=美食&sort=4&limit=10&latitude=%@&longitude=%@",latitude,longitude];
    
    [[[MOManager sharedManager] dpApi] requestWithURL:@"v1/business/find_businesses" paramsString:paramsString delegate:self];
}

#pragma mark - dpRequest delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	

    NSLog(@"Error从大众点评返回：%@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(NSDictionary*)result {
    
	//NSLog(@"成功从大众点评返回：%@,地址是：%@",result[@"businesses"][0][@"name"],result[@"businesses"][0][@"address"]);
    NSArray *businesses = result[@"businesses"];
    
    if (businesses.count>0) {
        int random = arc4random() % (businesses.count-1);
        NSDictionary *business = businesses[random];
        self.currentBusiness = [MTLJSONAdapter modelOfClass:[MOBusiness class] fromJSONDictionary:business error:nil];
    }
    
}

#pragma mark - tableview delegate


@end
