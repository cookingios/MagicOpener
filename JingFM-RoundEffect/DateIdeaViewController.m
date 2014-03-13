//
//  DateIdeaViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-10-16.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "DateIdeaViewController.h"

@interface DateIdeaViewController (){
    
    PFObject * currentDateIdea;
}

@property (weak, nonatomic) IBOutlet JingRoundView *roundView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *dateIdeaTextView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;






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
    //配置RoundView
    self.roundView.delegate = self;
    self.roundView.roundImage = [UIImage imageNamed:@"max04"];
    self.roundView.rotationDuration = 8.0;
    self.roundView.isPlay = NO;
    
    self.scrollView.contentSize=CGSizeMake(320,520);
    
    _temperatureLabel.layer.cornerRadius= 5.0f;
    _temperatureLabel.layer.masksToBounds = YES ;
    [_dateIdeaTextView setEditable:NO];
    [_dateIdeaTextView setSelectable:NO];
    [_commentTextView setEditable:NO];
    [_commentTextView setSelectable:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    
    _dateIdeaTextView.text=@"这里是精彩约会点子的密室!";
    _commentTextView.text=@"视节操为生命的mimi小助手将竭诚为你服务：）";

    PFQuery *query = [PFQuery queryWithClassName:@"DateIdea"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 60 * 60 * 24;
    [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"Successfully retrieved %d openers.", objects.count);
            
        } else {
            
            NSLog(@"failed because %@ ", error);
        }
    }];
    
}
/*
- (void)viewDidAppear:(BOOL)animated{
    //若为iphone5,启动后play,iphone5以下机型Stop
    if ((![self.roundView isPlay])&& iPhone5) {
        
        [self performSelector:@selector(initPlay) withObject:nil afterDelay:0.5];
        
    }
    
    if (!iPhone5) {
        [self.scrollView setContentOffset:CGPointMake(0, 20) animated:NO];
        [self.roundView pause];
    }
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 魔盘启动 & 状态变更
-(void)initPlay{
    
    [self.roundView play];
    
}


-(void)playStatuUpdate:(BOOL)playState{
    //停止转动
    if (!playState) {
            PFQuery *query = [PFQuery queryWithClassName:@"DateIdea"];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            
            query.maxCacheAge = 60 * 60 * 48 ;
            [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %d openers.", objects.count);
                    
                    if (objects.count>0) {
                        int x = arc4random() % (objects.count-1);
                        currentDateIdea = [objects objectAtIndex:x];
                        NSString *dateIdea=[currentDateIdea objectForKey:@"idea"];
                        self.dateIdeaTextView.text=[NSString stringWithFormat:@"%@",dateIdea] ;
                        self.commentTextView.text=[currentDateIdea objectForKey:@"description"];
                        [self refreshTemperature:[currentDateIdea objectForKey:@"rate"]];
                        [self.commentTextView setNeedsLayout];
                        NSLog(@"the date idea is %@",dateIdea);
                        NSLog(@"current opener is %@",[currentDateIdea objectId]);
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"该分类无数据" message:@"切换到全部" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                    
                } else {
                    // The network was inaccessible and we have no cached data for
                    // this query.
                    NSLog(@"failed because %@ ", error);
                }
            }];
        //开始转动
        }else{

            
        }
}


-(void)refreshTemperature:(NSNumber *)number{
    
    if (number) {
        switch ([number intValue]) {
            case 1:
                self.temperatureLabel.text = @"感情达到 0~25℃";
                self.temperatureImageView.image = [UIImage imageNamed:@"cold"];
                break;
            case 2:
                self.temperatureLabel.text = @"感情达到 26~50℃";
                self.temperatureImageView.image = [UIImage imageNamed:@"warm"];
                break;
            case 3:
                self.temperatureLabel.text = @"感情达到 51~75℃";
                self.temperatureImageView.image = [UIImage imageNamed:@"hot"];
                break;
            case 4:
                self.temperatureLabel.text = @"感情达到 76~99℃";
                self.temperatureImageView.image = [UIImage imageNamed:@"boiling"];
                break;
            
            default:
                break;
        }
        
    }

}
/*
#pragma mark - 菜单 DataSource & delegate
-(IBAction)showMenu:(id)sender{
    
    NSArray *images = @[
                        [UIImage imageNamed:@"SideBarItemOpener"],
                        [UIImage imageNamed:@"SideBarItemDateIdea"],
                        [UIImage imageNamed:@"SideBarItemUpload"],
                        //[UIImage imageNamed:@"SideBarItemLogout"],
                        ];
    NSArray *titles = @[
                        @"开场",
                        @"邀约",
                        @"求助",
                        //@"登出",
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        //[UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    //RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images titles:titles];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images titles:titles selectedIndices:[NSIndexSet indexSetWithIndex:1] borderColors:colors];
    callout.delegate = self;
    [callout show];
    
}

*/
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    NSLog(@"Tapped item at index %i",index);
    [sidebar dismissAnimated:YES];
    
    switch (index) {
        case 0:
            NSLog(@"tap DateIdea");
            [self performSegueWithIdentifier:@"OpenerSegue" sender:self];
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


@end
