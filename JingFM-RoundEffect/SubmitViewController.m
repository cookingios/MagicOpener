//
//  SubmitViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-3-15.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "SubmitViewController.h"
#import <RPFloatingPlaceholderTextView.h>


@interface SubmitViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak,nonatomic) IBOutlet  RPFloatingPlaceholderTextView* contentTextView;

@property (strong,nonatomic) PFFile *screenshot;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) PFUser *toUser;
@property (strong,nonatomic) NSString *toUserId;
@property (strong,nonatomic) NSString *type;

- (IBAction)submit:(id)sender;

@end

@implementation SubmitViewController

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
    //文字内容
    self.contentTextView.delegate = self;
    self.contentTextView.animationDirection = RPFloatingPlaceholderAnimateDownward;
    self.contentTextView.floatingLabelActiveTextColor = [UIColor lightGrayColor];
    self.contentTextView.placeholder = @"说点什么呢...";
    //截图
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    [self.eventImageView addGestureRecognizer:tap];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SubmitQuestionType1"];
    //NSLog(@"toUser is %@",[self.toUser description]);
    [TSMessage setDefaultViewController:self.navigationController];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SubmitQuestionType1"];
    
}
- (void)selectImage{
    [self takePictureFromPhotoLibrary];
}

- (void)takePictureFromPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:NO];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1f);
    
    [self.eventImageView setImage:[UIImage imageWithData:imgData]];
    self.screenshot = [PFFile fileWithData:imgData];
    
    [self.screenshot saveInBackground];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (IBAction)submit:(id)sender {
    if ((!self.screenshot) && [self.contentTextView.text isEqualToString:@""]) {
        return [self showErrorMessage:@"需文字描述或上传聊天记录截图"];
    }
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    [self.hud show:YES];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    
    self.toUser = [PFQuery getUserObjectWithId:self.toUserId];
    
    if (!self.toUser) {
        return [self showErrorMessage:@"无法获取情感专家信息,请检查网络"];
    }
    
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    if (self.screenshot) {
        [message setObject:self.screenshot forKey:@"screenshot"];
    }
    
    if (![self.contentTextView.text isEqualToString:@""]){
        [message setObject:self.contentTextView.text forKey:@"problem"];
    }
    [message setObject:[NSNumber numberWithBool:NO] forKey:@"isReplyed"];
    [message setObject:[NSNumber numberWithBool:NO] forKey:@"isRead"];
    [message setObject:[PFUser currentUser] forKey:@"fromUser"];
    [message setObject:self.toUser forKey:@"expert"];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [timer invalidate];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"成功提交";
            [_hud hide:YES afterDelay:2];
            //推送
            //if (![[self.toUser objectId]isEqualToString:[[PFUser currentUser] objectId]]) {
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:self.toUser]; // Set notification toUser
                //Create Options
                NSDictionary *data = @{
                                       @"alert":@"你收到一条求助信息",
                                       @"eventId":message.objectId,
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

- (void)showErrorMessage:(NSString*)message{
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
}

- (void)handleHudTimeout{
    
    self.hud.mode = MBProgressHUDModeText;
	self.hud.labelText = @"网络连接有问题";
    [self.hud hide:YES afterDelay:3];
}
@end
