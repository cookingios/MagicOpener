//
//  MessageDetailTableViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-5-29.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "MessageDetailTableViewController.h"
#import <UIImageView+WebCache.h>

@interface MessageDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *evaluateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *helperLabel;
@property (strong,nonatomic) ASMediaFocusManager *mediaFocusManager;
@property (strong,nonatomic) TQStarRatingView *starRatingView;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) NSNumber *score;


- (IBAction)submitEvaluation:(id)sender;

@end

@implementation MessageDetailTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
    [self.mediaFocusManager installOnView:self.questionImageView];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MessageDetail"];
    
    
    self.starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(85, 15, 150, 30)
                                                                  numberOfStar:5];
    self.starRatingView.delegate = self;
    [self.starRatingView setScore:0 withAnimation:NO];
    [self.evaluateView addSubview:self.starRatingView];
    
    self.questionLabel.text = [NSString stringWithFormat:@"\" %@ \"", [self.message objectForKey:@"problem"]];
    self.answerLabel.text = [NSString stringWithFormat:@"\" %@ \"", [self.message objectForKey:@"reply"]];
    self.helperLabel.text = [NSString stringWithFormat:@"by %@", [[self.message objectForKey:@"expert"] objectForKey:@"displayName"]];
    [self.questionImageView setImageWithURL:[NSURL URLWithString:[(PFFile *)[self.message objectForKey:@"screenshot"] url]]];
    
    if ([[self.message allKeys] containsObject:@"star"]) {
        self.evaluateView.superview.superview.hidden = YES;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MessageDetail"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    self.score = [NSNumber numberWithFloat:score *5];
    if (score) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%0.1f 分",score * 5];
        
    }else{
        self.scoreLabel.text = @"评价回复";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 3;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSParagraphStyleAttributeName:pStyle};
    //Answer cell 高度
    CGRect rect = [self.answerLabel.text boundingRectWithSize:CGSizeMake(246, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    //Question cell 高度
    CGRect rect2 = [self.questionLabel.text boundingRectWithSize:CGSizeMake(165, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
    
    

    
    int index = indexPath.row;
    switch (index) {
        case 0:
            // Get the string of text from each comment
            if (rect2.size.height<138) {
                return 152;
            }else{
                return 14 + rect2.size.height;
            }
            break;
        case 1:
            // Get the string of text from each comment
            if (rect.size.height<107) {
                return 152;
            }else{
                return 45 + rect.size.height;
            }
            break;
        case 2:
            return 64.0f;
            break;
            
            
        default:
            return 64.0f;
            break;
    }
    
    
}

#pragma mark - ASMediaFocusDelegate
// Returns an image view that represents the media view. This image from this view is used in the focusing animation view. It is usually a small image.
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view;
{
    return [(UIImageView *)view image];
}

// Returns the final focused frame for this media view. This frame is usually a full screen frame.
- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view;
{
   return self.parentViewController.view.bounds;
}

// Returns the view controller in which the focus controller is going to be added.
// This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager;
{
    return self.parentViewController;
}


// Returns an URL where the image is stored. This URL is used to create an image at full screen. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view;
{
    NSURL *url = [NSURL URLWithString:[(PFFile *)[self.message objectForKey:@"screenshot"] url]];
    
    return url;
}


// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    return @"问题截图";
}

- (IBAction)submitEvaluation:(id)sender {
    
    float number = [self.score floatValue];
    if (number>0.1) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.hud];
        [self.hud show:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];

        [self.message setObject:self.score forKey:@"star"];
        [self.message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [timer invalidate];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"成功提交";
                [_hud hide:YES afterDelay:2];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分数不能为0哦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)handleHudTimeout{
    
    self.hud.mode = MBProgressHUDModeText;
	self.hud.labelText = @"网络连接有问题";
    [self.hud hide:YES afterDelay:3];
}

@end
