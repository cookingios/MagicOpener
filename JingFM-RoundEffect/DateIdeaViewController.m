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
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentGeoPoint.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentGeoPoint.longitude];
    
    NSString *basicString = [self paramsStringWithOptionIndex:self.relationshipTypeSegment.selectedSegmentIndex];
    NSString *paramsString = [basicString stringByAppendingString:[NSString stringWithFormat:@"&latitude=%@&longitude=%@",latitude,longitude]];
    
    [[[MOManager sharedManager] dpApi] requestWithURL:@"v1/business/find_businesses" paramsString:paramsString delegate:self];
}

//约会地点根据情感关系配置
-(NSString*)paramsStringWithOptionIndex:(NSInteger)index{
    
    NSString *params = nil;
    switch (index) {
        case 0:
            params = @"category=面包甜点,咖啡,公园&limit=40&sort=1";
            break;
        case 1:
            params = @"category=美食,电影院,运动健身&limit=40&sort=1";
            break;
        case 2:
            params = @"category=酒店,KTV,足疗按摩,酒吧&limit=40&sort=1";
            break;
            
        default:
            break;
    }
    return params;
}

//约会话题根据情感关系配置
-(PFQuery*)queryTopicWithOptionIndex:(NSInteger)index{
    

}

//约会互动根据情感关系配置
-(PFQuery*)queryInteractWithOptionIndex:(NSInteger)index{
    
    
}

#pragma mark - dpRequest delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	

    NSLog(@"Error从大众点评返回：%@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(NSDictionary*)result {
    
	//NSLog(@"成功从大众点评返回：%@,地址是：%@",result[@"businesses"][0][@"name"],result[@"businesses"][0][@"address"]);
    NSArray *businesses = result[@"businesses"];
    
    if (businesses.count>0) {
        int random1 = arc4random() % businesses.count;
        NSDictionary *business = businesses[random1];
        self.currentBusiness = [MTLJSONAdapter modelOfClass:[MOBusiness class] fromJSONDictionary:business error:nil];
        [(DateIdeaItem*)self.datasource[0] setContent:self.currentBusiness.name];
        [(DateIdeaItem*)self.datasource[0] setDescription:self.currentBusiness.address];
        
        int random2 = arc4random() % 26;
        PFQuery *queryTopic = [PFQuery queryWithClassName:@"ChatTopic"];
        [queryTopic whereKey:@"type" equalTo:@"first"];
        queryTopic.skip = random2;
        queryTopic.limit = 1;
        
        int random3 = arc4random() % 16;
        PFQuery *queryOpener = [PFQuery queryWithClassName:@"Opener"];
        [queryOpener whereKey:@"scene" equalTo:@"date"];
        queryOpener.skip = random3;
        queryOpener.limit = 1;
        
        int random4 = arc4random() % 24;
        PFQuery *queryInteract = [PFQuery queryWithClassName:@"DateIdea"];
        [queryInteract whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
        queryInteract.skip = random4;
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
        }] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
            NSArray *result = task.result;
            PFObject *interact = result[0];
            [(DateIdeaItem*)self.datasource[3] setContent:[interact objectForKey:@"idea"]];
            [(DateIdeaItem*)self.datasource[3] setDescription:[interact objectForKey:@"description"]];
            
            [self.tableView reloadData];
            
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.tableView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
            
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
