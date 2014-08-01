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
#import "DateIdeaCell.h"
#import "DateIdeaItem.h"

@interface DateIdeaViewController ()<DPRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@property (readonly,nonatomic) DPAPI *dpApi;
@property (strong,nonatomic) MOBusiness *currentBusiness;
@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) PFGeoPoint *currentGeoPoint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *relationshipTypeSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Custom initialization
        DateIdeaItem *place = [[DateIdeaItem alloc] initWithTitle:@"约会地点" imageName:@"date-icon-place"];
        DateIdeaItem *opener = [[DateIdeaItem alloc] initWithTitle:@"开场白" imageName:@"date-icon-opener"];
        DateIdeaItem *topic = [[DateIdeaItem alloc] initWithTitle:@"聊天话题" imageName:@"date-icon-topic"];
        DateIdeaItem *goodbye = [[DateIdeaItem alloc] initWithTitle:@"互动点子" imageName:@"date-icon-interact"];
        
        self.datasource = @[place,opener,topic,goodbye];
        
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
        [(DateIdeaItem*)self.datasource[0] setContent:self.currentBusiness.name];
        [(DateIdeaItem*)self.datasource[0] setDescription:self.currentBusiness.address];
        
        PFQuery *queryTopic = [PFQuery queryWithClassName:@"ChatTopic"];
        [queryTopic whereKey:@"type" equalTo:@"first"];
        queryTopic.skip = (int)random % 25;
        queryTopic.limit = 1;
        
        PFQuery *queryOpener = [PFQuery queryWithClassName:@"Opener"];
        [queryOpener whereKey:@"scene" equalTo:@"date"];
        queryOpener.skip = (int)random % 15;
        queryOpener.limit = 1;
        
        PFQuery *queryInteract = [PFQuery queryWithClassName:@"DateIdea"];
        [queryInteract whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
        queryInteract.skip = (int)random % 23;
        queryInteract.limit = 1;
        
        [[[[MOUtility findAsync:queryTopic] continueWithSuccessBlock:^id(BFTask *task) {
            
            NSArray *result = task.result;
            PFObject *topic = result[0];
            [(DateIdeaItem*)self.datasource[2] setContent:[topic objectForKey:@"topic"]];
            [(DateIdeaItem*)self.datasource[2] setDescription:[topic objectForKey:@"description"]];
            
            
            
            return [MOUtility findAsync:queryOpener];
        }] continueWithSuccessBlock:^id(BFTask *task) {
            
            NSArray *result = task.result;
            PFObject *opener = result[0];
            [(DateIdeaItem*)self.datasource[1] setContent:[opener objectForKey:@"opener"]];
            [(DateIdeaItem*)self.datasource[1] setDescription:[opener objectForKey:@"description"]];
            
            return [MOUtility findAsync:queryInteract];
        }] continueWithSuccessBlock:^id(BFTask *task) {
            NSArray *result = task.result;
            PFObject *interact = result[0];
            [(DateIdeaItem*)self.datasource[3] setContent:[interact objectForKey:@"idea"]];
            [(DateIdeaItem*)self.datasource[3] setDescription:[interact objectForKey:@"description"]];
            
            [self.tableView reloadData];
            
            return nil;
        }];
        
        
    }
    
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.datasource count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"DateIdeaCell";
    
    DateIdeaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DateIdeaCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }
    // Configure the cell to show todo item with a priority at the bottom
    cell.titleLabel.text = [self.datasource[indexPath.row] title];
    cell.contentLable.text = [self.datasource[indexPath.row] content];
    cell.descriptionLabel.text = [self.datasource[indexPath.row] description];
    cell.iconImageView.image = [UIImage imageNamed:[self.datasource[indexPath.row] imageName]];
    
    return cell;

    
}



@end
