//
//  ViewController.m
//  JingFM-RoundEffect
//
//  Created by isaced on 13-6-6.
//  Copyright (c) 2013年 isaced. All rights reserved.
//  By isaced:http://www.isaced.com/

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

- (IBAction)showCatagory:(id)sender;
- (IBAction)duplicateOpener:(id)sender;


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
    self.title=@"微信.陌陌";
    self.category=1;
    [_openerLabel setEditable:NO];
    [_openerLabel setSelectable:NO];
    [_commentTextView setEditable:NO];
    [_commentTextView setSelectable:NO];
    _baseScrollView.contentSize=CGSizeMake(320,520);
    _starDecorateLabel.layer.cornerRadius = 5.0f;
    _starDecorateLabel.layer.masksToBounds = YES;
    
}


/*
-(void)viewWillAppear:(BOOL)animated{
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        _openerLabel.text=@"魔盘停止转动时，精彩开场白将逐一呈现!";
        _commentTextView.text=@"视节操为生命的mimi小助手将竭诚为你服务：）";

        UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
        self.navigationItem.leftBarButtonItem =menuButton;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Opener"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        if (!(self.category==0)) {
            [query whereKey:@"scene" equalTo:[MOUtility getSceneByIndex:_category]];
        }
        query.maxCacheAge = 60 * 60 * 24;
        [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {

                NSLog(@"Successfully retrieved %d openers.", objects.count);
                
            } else {

                NSLog(@"failed because %@ ", error);
            }
        }];

    }else{
    
        _openerLabel.text=@"魔术转盘停止转动时，精彩开场白将逐一呈现!";
        _commentTextView.text=@"非注册用户最多展示三条，免费注册后可开启所有功能,含“mimi小助手点评”及“分类查询”。";
        _starImageView.image = [UIImage imageNamed:@"0star"];
    
    }
    
}
*/
/*
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
*/
 
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

/*
-(void)playStatuUpdate:(BOOL)playState
{
    NSLog(@"%@...", playState ? @"播放": @"暂停了");

    if (!playState) {
        
        //
        if ([PFUser currentUser]) {
            PFQuery *query = [PFQuery queryWithClassName:@"Opener"];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            
            if (!(self.category==0)) {
                [query whereKey:@"scene" equalTo:[MOUtility getSceneByIndex:_category]];
            }
            
            query.maxCacheAge = 60 * 60 * 48 ;
            [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
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
*/

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
/*
-(IBAction)showMenu:(id)sender{
    
    NSArray *images = @[
                        [UIImage imageNamed:@"SideBarItemOpener"],
                        [UIImage imageNamed:@"SideBarItemDateIdea"],
                        [UIImage imageNamed:@"SideBarItemUpload"],
                        ];
    NSArray *titles = @[
                        @"开场",
                        @"邀约",
                        @"求助",
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        //[UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images titles:titles selectedIndices:[NSIndexSet indexSetWithIndex:0] borderColors:colors];
    callout.delegate = self;    
    [callout show];
    
}
*/

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



#pragma mark - 场景 Category DataSaurce & delegate
- (IBAction)showCatagory:(id)sender {
    
    NSInteger numberOfOptions = 4;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"all"] title:@"全部"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"sns"] title:@"微信.陌陌"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"club"] title:@"酒吧.夜店"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"street"] title:@"商场.街搭"],
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    
    
}


/*
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex{
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"现在还不行呢" message:@"注册后可使用分类查看" delegate:self cancelButtonTitle:@"好吧我知道了" otherButtonTitles:nil];
        [alert show];
    }else{
        //设置分类选项
        [self setCategory:itemIndex];
        //选择分类后，向后台查询
        self.title=item.title;
        PFQuery *query = [PFQuery queryWithClassName:@"Opener"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        //缓存期一天
        query.maxCacheAge = 60 * 60 * 24;
        //根据index决定查询条件
        if (!(itemIndex==0)) {
            [query whereKey:@"scene" equalTo:[MOUtility getSceneByIndex:itemIndex]];
        }
        [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {

                NSLog(@"Successfully retrieved %d openers.", objects.count);
                
            } else {
                // The network was inaccessible and we have no cached data for
                // this query.
                NSLog(@"failed because %@ ", error);
            }
        }];
    }
    
}
*/

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

}


@end
