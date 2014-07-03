//
//  ExpertMessageDetailTableViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-6-6.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ExpertMessageDetailTableViewController.h"
#import <UIImageView+WebCache.h>


@interface ExpertMessageDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *evaluateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (strong,nonatomic) ASMediaFocusManager *mediaFocusManager;

- (IBAction)submitAnswer:(id)sender;

@end

@implementation ExpertMessageDetailTableViewController

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
    
    [super viewWillAppear:YES];
     [TSMessage setDefaultViewController:self.navigationController];
    
    [self.message refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSNumber *star = [self.message objectForKey:@"star"];
        if (star) {
            self.scoreLabel.text = [NSString stringWithFormat:@"%@ 分",star];
        }else if ([star isEqualToNumber:0]){
            self.scoreLabel.text =@"0 分";
        }else {
            self.scoreLabel.text =@"未评分";
        }
        
    }];
    
    self.questionLabel.text = [NSString stringWithFormat:@"\" %@ \"", [self.message objectForKey:@"problem"]];
    self.inputTextView.text = [self.message objectForKey:@"reply"];
    [self.questionImageView setImageWithURL:[NSURL URLWithString:[(PFFile *)[self.message objectForKey:@"screenshot"] url]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 3;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSParagraphStyleAttributeName:pStyle};
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
            return 152;
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

- (IBAction)submitAnswer:(id)sender {
    
    NSString *trimInputString = [MOUtility trimString:self.inputTextView.text];
    
    if ([trimInputString isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"内容不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        return [alert show];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否确定提交以下内容做为回复?" message:self.inputTextView.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [self.message setValue:self.inputTextView.text forKey:@"reply"];
        [self.message setValue:[NSNumber numberWithBool:YES] forKey:@"isReplyed"];
        [self.message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //推送
                //if (![[self.toUser objectId]isEqualToString:[[PFUser currentUser] objectId]]) {
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:[self.message objectForKey:@"fromUser"]]; // Set notification toUser
                //Create Options
                NSString *expertName = [NSString stringWithFormat:@"收到%@的回复信息",[[self.message objectForKey:@"expert"] objectForKey:@"displayName"]];
                NSDictionary *data = @{
                                       @"alert":expertName,
                                       @"eventId":self.message.objectId,
                                       @"badge":@"Increment",
                                       @"sound":@"Voidcemail.caf"
                                       };
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushQuery];
                [push setData:data];
                [push sendPushInBackground];
                //}
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showErrorMessage:@"网络连接问题,稍后再试"];
            }

        }];
        
    }
}

- (void)showErrorMessage:(NSString*)message{
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
}

@end
