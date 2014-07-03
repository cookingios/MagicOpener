//
//  ViewController.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UITextView *openerLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDecoLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starDecorateLabel;
@property (unsafe_unretained,nonatomic) NSInteger category;
@property (strong,nonatomic) PFObject *currentOpener;
@property (copy,nonatomic) NSMutableArray *guestDataSaurce;
@property (unsafe_unretained,nonatomic) NSInteger guestCount;
@property (copy,nonatomic) NSMutableArray *guestStars;


- (IBAction)duplicateOpener:(id)sender;
- (IBAction)switchOpenerMode:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //配置RoundView
    self.roundView.delegate = self;
    self.roundView.roundImage = [UIImage imageNamed:@"max"];
    self.roundView.rotationDuration = 8.0;
    self.roundView.isPlay = NO;
    //访客配置
    self.guestCount=0;
    self.guestDataSaurce =[[NSMutableArray alloc]initWithObjects:@"你好啊，今晚的天空很幽默呢。",@"你是混血儿么?(对方:为什么？)看起来像北京混西雅图",@"为什么你给我的第一感觉，不像用陌陌的女人。",nil];
    self.guestStars =[[NSMutableArray alloc]initWithObjects:@1,@3,@5,nil];
    //页面初始配置
    self.category=1;
    [_openerLabel setEditable:NO];
    [_openerLabel setSelectable:NO];
    [_commentTextView setEditable:NO];
    [_commentTextView setSelectable:NO];
    _baseScrollView.contentSize=CGSizeMake(320,520);
    _starDecorateLabel.layer.cornerRadius = 5.0f;
    _starDecorateLabel.layer.masksToBounds = YES;
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OldOpener"];
   
    _openerLabel.text=@"魔盘停止转动时，精彩开场白将逐一呈现!";
    _commentTextView.text=@"视节操为生命的mimi小助手将竭诚为你服务：）";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Opener"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 60 * 60 * 24;
    //[query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [query whereKey:@"scene" equalTo:@"sns"];
    [query whereKey:@"rate" lessThan:@5];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSLog(@"Successfully retrieved %d openers.", objects.count);
            
        } else {

            NSLog(@"failed because %@ ", error);
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OldOpener"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    //若为iphone5,启动后play,iphone5以下机型Stop
    if ((![self.roundView isPlay])&& iPhone5) {
        
        [self performSelector:@selector(initPlay) withObject:nil afterDelay:0.5];
        
    }
    
    if (!iPhone5) {
        [self.baseScrollView setContentOffset:CGPointMake(0, 20) animated:NO];
        [self.roundView pause];
    }

}

 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}





#pragma mark - 登录
-(IBAction)loginBtnPress:(id)sender{
    
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    
}


#pragma mark - 魔盘启动 & 状态变更
-(void)initPlay{
    
    [self.roundView play];
    
}


-(void)playStatuUpdate:(BOOL)playState
{
    NSLog(@"%@...", playState ? @"播放": @"暂停了");
    
    if (!playState) {
        //统计
        NSDictionary *dict = @{@"type":@"classic"};
        [MobClick event:@"GetOpener" attributes:dict];
        //
        if ([PFUser currentUser]) {
            PFQuery *query = [PFQuery queryWithClassName:@"Opener"];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            query.maxCacheAge = 60 * 60 * 48 ;
            //[query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
            [query whereKey:@"scene" equalTo:@"sns"];
            [query whereKey:@"rate" lessThan:@5];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSLog(@"Successfully retrieved %d openers.", objects.count);
                    
                    if (objects.count>0) {
                        int x = arc4random() % (objects.count-1);
                        _currentOpener = [objects objectAtIndex:x];
                        NSString *opener=[_currentOpener objectForKey:@"opener"];
                        NSLog(@"the opener is %@",opener);
                        NSLog(@"current opener is %@",[_currentOpener objectId]);
                        self.openerLabel.text=[NSString stringWithFormat:@"%@",opener] ;
                        self.commentTextView.text=[_currentOpener objectForKey:@"description"];
                        [self showStar:[_currentOpener objectForKey:@"rate"]];
                        [self.commentDecoLabel setNeedsLayout];
                        [self.commentTextView setNeedsLayout];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"该分类无数据" message:@"切换到全部" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                        self.category=1;
                        self.title=@"微信.陌陌";
                    }
                    
                    
                } else {
                    // The network was inaccessible and we have no cached data for
                    // this query.
                     NSLog(@"failed because %@ ", error);
                }
            }];
            
        }else{
            if (_guestCount==3){
                _guestCount=0;
            }
            self.openerLabel.text=[_guestDataSaurce objectAtIndex:_guestCount];
            [self showStar:[_guestStars objectAtIndex:_guestCount]];
            _guestCount++;
        }
    
    }else{
        
    
    }

}


-(void)showStar:(NSNumber *)starCounts{
    if (starCounts) {
        switch ([starCounts intValue]) {
            case 1:
                _starImageView.image =[UIImage imageNamed:@"1star"];
                break;
            case 2:
                _starImageView.image =[UIImage imageNamed:@"2star"];
                break;
            case 3:
                _starImageView.image =[UIImage imageNamed:@"3star"];
                break;
            case 4:
                _starImageView.image =[UIImage imageNamed:@"4star"];
                break;
            case 5:
                _starImageView.image =[UIImage imageNamed:@"5star"];
                break;
                
            default:
                break;
        }
    }else{
         _starImageView.image =[UIImage imageNamed:@"0star"];
    }
}

#pragma mark - 菜单 DataSource & delegate
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    NSLog(@"Tapped item at index %i",index);
    [sidebar dismissAnimated:YES];
    
    switch (index) {
        case 1:
            NSLog(@"tap DateIdea");
            [self performSegueWithIdentifier:@"DateIdeaSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"HelpSegue" sender:self];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 复制
- (IBAction)duplicateOpener:(id)sender {
    //复制到黏贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.openerLabel.text;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.delegate = self;
    
    if (self.category == 1) {
        HUD.labelText = @"复制好了,赶紧去微信/陌陌试试吧";
    }else HUD.labelText = @"已复制到黏贴板";
    
    [self.navigationController.view addSubview:HUD];
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
    
    NSDictionary *dict = @{@"opener":pasteboard.string,@"type":@"classic"};
    [MobClick event:@"DuplicateOpener" attributes:dict];

}

- (IBAction)switchOpenerMode:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
