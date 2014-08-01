//
//  HomeViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-2-22.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "HomeViewController.h"
#import "OpenerView.h"
#import <MBProgressHUD.h>
#import <RESideMenu.h>
#import <UIImageView+UIImageView_FaceAwareFill.h>
#import "FaceppAPI.h"


@interface HomeViewController (){
    MBProgressHUD *hud;
}

@property (nonatomic) BOOL isFreeChanceUsing;
@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSNumber *life;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *starDecorateLabel;

- (IBAction)showMenu:(id)sender;
- (IBAction)freeLookUp:(id)sender;
- (IBAction)buy1YearProVersion:(id)sender;
- (IBAction)switchOpenerMode:(id)sender;
- (IBAction)duplicateOpener:(id)sender;


@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataSource =@[@{@"about":@"根据你要搭讪的对象照片，约会助手将帮你分析她的年龄，衣着和配饰等因素，挑选最合适的三个开场白；\n \n用户上传头像照片将放在本地,不会上传至服务器."}];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
    [self.avatarImageView addGestureRecognizer:tap];
    //[self getOpeners];
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled = YES;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    _isFreeChanceUsing = NO;
    
    self.duplicateButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Opener"];
    
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"WelcomeSegue" sender:self];
    }
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"life remain %@",[[PFUser currentUser] objectForKey:@"freeChance"]);
    }];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Opener"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)freeLookUp:(id)sender {
    //TODO:待添加hud
    NSNumber *freeChance = [[PFUser currentUser] objectForKey:@"freeChance"];
    if ([freeChance integerValue] > 0) {
        
        [[PFUser currentUser] incrementKey:@"freeChance" byAmount:@-1];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [sender superview].hidden = YES;
                self.isFreeChanceUsing = YES;
            }
            
        }];
    }
    
}

- (IBAction)buy1YearProVersion:(id)sender {
    NSLog(@"bought");
    [PFPurchase buyProduct:@"1YearProVersion" block:^(NSError *error) {
        if (!error) {
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
            [sender superview].hidden = YES;
        }else{
            NSLog(@"error is %@",error);
        }
    }];
    
}

- (IBAction)switchOpenerMode:(id)sender {
    
    [MobClick event:@"SwitchMode"];
     
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"经典模式" message:@"经典模式将不会刷出五星开场白,是否继续?" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
    
    [alert show];
    
    [self performSegueWithIdentifier:@"ClassicModeSegue" sender:self];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (!buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 复制
- (IBAction)duplicateOpener:(id)sender {
    //复制到黏贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.dataSource[self.swipeView.currentItemIndex] objectForKey:@"opener"];
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.mode = MBProgressHUDModeCustomView;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	hud.delegate = self;
    
    hud.labelText = @"已复制到剪切板";
    
    [self.navigationController.view addSubview:hud];
	
	[hud show:YES];
	[hud hide:YES afterDelay:2];
    
    NSDictionary *dict = @{@"opener":pasteboard.string,@"type":@"picture"};
    [MobClick event:@"DuplicateOpener" attributes:dict];

}


- (void)selectImage{
    NSString *title = [NSString stringWithFormat:@"剩余次数:%@",[[PFUser currentUser] objectForKey:@"freeChance"]];
    if ([[[PFUser currentUser] objectForKey:@"freeChance"] isEqualToNumber:@0]) {
        //alertview 提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本日次数已用完" message:@"每日6次机会,凌晨12时前后更新." delegate:nil cancelButtonTitle:@"好的,我知道了" otherButtonTitles: nil];
        return [alert show];
    }else if(![[PFUser currentUser] objectForKey:@"freeChance"]){
        title = @"剩余次数:获取中";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍一张", @"从相册选择", nil];
    [actionSheet setTag:240];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet tag] == 240) {
        switch (buttonIndex) {
            case 0:
                [self takePhotoFromCamera];
                break;
                
            case 1:
                [self takePictureFromPhotoLibrary];
                break;
                
            default:
                break;
        }
    }
}

- (void)takePhotoFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:NO];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        
    }
}

- (void)takePictureFromPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:NO];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSData *imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.2f);
    
    UIImage *sourceImage = info[UIImagePickerControllerOriginalImage];
    UIImage *imageToDisplay = [MOUtility fixOrientation:sourceImage];
    NSData *imgData = UIImageJPEGRepresentation(imageToDisplay, 0.2f);
    [self.avatarImageView setImage:sourceImage];
    [self.avatarImageView faceAwareFill];
    //检测人脸
    [self performSelectorInBackground:@selector(detectWithImageData:) withObject:imgData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //初始化页面
    self.hintLabel.text = @"分析照片中...";
    self.swipeView.hidden = YES;
    self.starDecorateLabel.hidden = YES;
    self.starImageView.hidden = YES;
    _isFreeChanceUsing = NO;
    
    self.duplicateButton.hidden = YES;
 
}

- (void)detectWithImageData:(NSData *)imageData{
    
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:imageData mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeGender];
    
    NSString *hintContent = @"";
    if (result.success) {
        
        hintContent = [MOUtility getHintFromResult:[result content]];
        
        
        if ([hintContent isEqualToString:@"正在下载开场白"]) {
            
            NSDictionary *eyeleft = [result content][@"face"][0][@"position"][@"eye_left"];
            NSDictionary *mouthright = [result content][@"face"][0][@"position"][@"mouth_right"];
            NSInteger *random = (NSInteger *)([eyeleft[@"x"] intValue]*
                                [eyeleft[@"y"] intValue]*
                                [mouthright[@"x"] intValue]*
                                [mouthright[@"y"] intValue]);
            NSLog(@"random is %ld",(long)random);
            [self getOpenersWithRandomNumber:random];
        }
        
    }else{
        hintContent = @"网络连接错误";
    }
    
    [self performSelectorOnMainThread:@selector(setHint:) withObject:hintContent waitUntilDone:YES];
    
}

- (void)getOpenersWithRandomNumber:(NSInteger *)random {
    
    //统计
    NSDictionary *dict = @{@"type":@"picture"};
    [MobClick event:@"GetOpener" attributes:dict];
    
    [[PFUser currentUser] incrementKey:@"freeChance" byAmount:@-1];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSLog(@"life remain %@",[[PFUser currentUser] objectForKey:@"freeChance"]);
        }];
    }];
    
    PFQuery *queryLow = [PFQuery queryWithClassName:@"Opener"];
    [queryLow whereKey:@"rate" lessThan:@3];
    [queryLow whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [queryLow whereKey:@"scene" equalTo:@"sns"];
    queryLow.skip = (int)random % 25;
    queryLow.limit = 1;
    
    PFQuery *queryMedium = [PFQuery queryWithClassName:@"Opener"];
    [queryMedium whereKey:@"rate" lessThan:@5];
    [queryMedium whereKey:@"rate" greaterThan:@2];
    [queryMedium whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [queryMedium whereKey:@"scene" equalTo:@"sns"];
    queryMedium.skip = (int)random % 44;
    queryMedium.limit = 1;
    
    PFQuery *queryHigh = [PFQuery queryWithClassName:@"Opener"];
    [queryHigh whereKey:@"rate" equalTo:@5];
    [queryHigh whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [queryHigh whereKey:@"scene" equalTo:@"sns"];
    queryHigh.skip = (int)random % 26;
    queryHigh.limit = 1;
    
    NSMutableArray *ds = [NSMutableArray array];
    
    [[[[[MOUtility findAsync:queryLow] continueWithSuccessBlock:^id(BFTask *task) {
        NSArray *array = task.result;
        PFObject *opener = [array objectAtIndex:0];
        [ds addObject:opener];
       // NSLog(@"ds is %@",[self.dataSource description]);
        NSLog(@"lowlevel opener is %@",[opener objectForKey:@"opener"]);
        
        return [MOUtility findAsync:queryMedium];
    }] continueWithSuccessBlock:^id(BFTask *task) {
        
        NSArray *array = task.result;
        PFObject *opener = [array objectAtIndex:0];
        [ds addObject:opener];
        //NSLog(@"ds is %@",[self.dataSource description]);
        NSLog(@"Mediumlevel opener is %@",[opener objectForKey:@"opener"]);
        
        return [MOUtility findAsync:queryHigh];
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"error is %@",task.error);
            return nil;
        }else {
            NSArray *array = task.result;
            PFObject *opener = [array objectAtIndex:0];
            [ds addObject:opener];
            self.dataSource = [NSArray arrayWithArray:ds];
            //NSLog(@"ds is %ld",(long)[self.dataSource count]);
            NSLog(@"Highlevel opener is %@",[opener objectForKey:@"opener"]);
            [self.swipeView reloadData];
            return nil;
        }
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
        self.swipeView.hidden = NO;
        self.hintLabel.text = @"马上选一条开始搭讪吧";
        [self.swipeView scrollToItemAtIndex:0 duration:0];
        PFObject *currentObject = self.dataSource[0];
        NSString *starImageName = [MOUtility getImageNameByRate:[currentObject objectForKey:@"rate"]];
        _starImageView.image = [UIImage imageNamed:starImageName];
        self.starDecorateLabel.hidden = NO;
        self.starImageView.hidden = NO;
        self.duplicateButton.hidden = NO;
        
        return nil;
    }];
    
}

#pragma mark - swipeView dataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return [self.dataSource count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(OpenerView *)view
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(duplicateOpener:)];
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
    	view = [[NSBundle mainBundle] loadNibNamed:@"OpenerView" owner:self options:nil][0];
        
    }
    if ([self.dataSource[index] isKindOfClass:[PFObject class]]) {
        view.openerTextView.text = [self.dataSource[index] objectForKey:@"opener"];
        view.descriptionTextView.text = [self.dataSource[index] objectForKey:@"description"];
        [view.openerTextView addGestureRecognizer:tap];
        /*
        if ((![[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"1YearProVersion"]) && (index == 2) && (!_isFreeChanceUsing)) {
            view.payView.hidden = NO;
            [view.freeChanceButton setTitle:[NSString stringWithFormat:@"免费查看(%@)",[[PFUser currentUser] objectForKey:@"freeChance"]] forState:UIControlStateNormal];
        }
        */
    }else {
        view.openerTextView.text = [self.dataSource[0] objectForKey:@"about"];
        view.openerTextView.font = [UIFont systemFontOfSize:16];
        view.openerTextView.textColor = [UIColor lightGrayColor];
        view.openerTextView.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [UIColor clearColor];
        view.descriptionTextView.backgroundColor = [UIColor clearColor];
        
    }
    
    return view;
}

#pragma mark - swipeView delegate
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    
    if ([self.dataSource[0] isKindOfClass:[PFObject class]]) {
        PFObject *currentObject = self.dataSource[swipeView.currentItemIndex];
        NSString *starImageName = [MOUtility getImageNameByRate:[currentObject objectForKey:@"rate"]];
        _starImageView.image = [UIImage imageNamed:starImageName];
    }
}

- (void)setHint:(NSString *)content{
    
    self.hintLabel.text = content;
    
}
@end
