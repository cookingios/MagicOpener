//
//  SelectMyExpertViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-3-15.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "SelectMyExpertViewController.h"
#import <RESideMenu.h>
#import "MOExpert.h"

@interface SelectMyExpertViewController ()

@property (strong,nonatomic) NSString *toUserId;
@property (strong,nonatomic) NSArray * experts;
@property (strong,nonatomic) MOExpert *currentExpert;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) NSArray * editorsPicks;

- (IBAction)showMenu:(id)sender;
- (IBAction)reviewEditorPicks:(id)sender;


@end

@implementation SelectMyExpertViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MOExpert *wenlin = [[MOExpert alloc]initWithUserId:@"zlUNHVRCEX" name:@"张sir" avatar:[UIImage imageNamed:@"wenlin"] description:@"清新口味,卖萌常客"];
     MOExpert *neo = [[MOExpert alloc]initWithUserId:@"ZTLhLSzDf2"  name:@"尼奥" avatar:[UIImage imageNamed:@"neo"] description:@"理性调情,感性吸引"];
     MOExpert *chuan = [[MOExpert alloc]initWithUserId:@"DrIepaI8DF" name:@"川川" avatar:[UIImage imageNamed:@"hi"] description:@"女性的视角,解读女性"];
    
    self.experts = @[wenlin,neo,chuan];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Helper"];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Helper"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)reviewEditorPicks:(id)sender {

    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    [self.hud show:YES];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    //PFUser *toUser = [PFQuery getUserObjectWithId:self.currentExpert.userId];
    //获取当前expert
    self.currentExpert = self.experts[[sender tag]];
    [[[MOUtility findAsyncUser:self.currentExpert.userId] continueWithSuccessBlock:^id(BFTask *task) {
        PFUser *toUser = task.result;
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"expert" equalTo:toUser];
        [query whereKey:@"isEditorsPicked" equalTo:[NSNumber numberWithBool:YES]];
        query.limit = 5;
        
        return [MOUtility findAsync:query];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
        [timer invalidate];
        [self.hud removeFromSuperview];
        self.editorsPicks = [NSArray arrayWithArray:task.result];
        [self performSegueWithIdentifier:@"EditorsPicksSegue" sender:self];
        
        
        return nil;
    }];
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count]) {
            [timer invalidate];
            [self.hud removeFromSuperview];
            self.editorsPicks = [NSArray arrayWithArray:objects];
            [self performSegueWithIdentifier:@"EditorsPicksSegue" sender:self];
        }
        
    }];
    */
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.toUserId = [(MOExpert*)self.experts[indexPath.row] userId];
    
    [self performSegueWithIdentifier:@"SelectQuestionTypeSegue" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id dvc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SelectQuestionTypeSegue"]) {
        [dvc setValue:self.toUserId forKey:@"toUserId"];
        
    } else if ([segue.identifier isEqualToString:@"EditorsPicksSegue"]){
        [dvc setValue:self.currentExpert forKey:@"expert"];
        [dvc setValue:self.editorsPicks forKey:@"dataSource"];
    }
}

- (void)handleHudTimeout{
    
    self.hud.mode = MBProgressHUDModeText;
	self.hud.labelText = @"网络连接有问题";
    [self.hud hide:YES afterDelay:3];
}

@end
