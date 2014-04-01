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
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starDecorateLabel;


@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSNumber *life;
@property (nonatomic) BOOL isFreeChanceUsing;

- (IBAction)showMenu:(id)sender;
- (IBAction)freeLookUp:(id)sender;
- (IBAction)buy1YearProVersion:(id)sender;


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
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"WelcomeSegue" sender:self];
    }
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"life remain %@",[[PFUser currentUser] objectForKey:@"life"]);
    }];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    
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
    
}


- (void)selectImage{
    NSString *title = [NSString stringWithFormat:@"本日剩余次数:%@",[[PFUser currentUser] objectForKey:@"life"]];
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
    
    PFQuery *queryLow = [PFQuery queryWithClassName:@"Opener"];
    [queryLow whereKey:@"rate" lessThan:@4];
    [queryLow whereKey:@"scene" equalTo:@"sns"];
    queryLow.skip = (int)random %61;
    queryLow.limit = 1;
    
    PFQuery *queryMedium = [PFQuery queryWithClassName:@"Opener"];
    [queryMedium whereKey:@"rate" equalTo:@4];
    [queryMedium whereKey:@"scene" equalTo:@"sns"];
    queryMedium.skip = (int)random %24;
    queryMedium.limit = 1;
    
    PFQuery *queryHigh = [PFQuery queryWithClassName:@"Opener"];
    [queryHigh whereKey:@"rate" equalTo:@5];
    [queryHigh whereKey:@"scene" equalTo:@"sns"];
    queryHigh.skip = (int)random %33;
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
    }]continueWithBlock:^id(BFTask *task) {
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
        return nil;
    }];
    
}

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
    	view = [[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil][0];
        
    }
    if ([self.dataSource[index] isKindOfClass:[PFObject class]]) {
        view.openerTextView.text = [self.dataSource[index] objectForKey:@"opener"];
        view.descriptionTextView.text = [self.dataSource[index] objectForKey:@"description"];
        [view.openerTextView addGestureRecognizer:tap];
        
        if ((![[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"1YearProVersion"]) && (index == 2) && (!_isFreeChanceUsing)) {
            view.payView.hidden = NO;
            [view.freeChanceButton setTitle:[NSString stringWithFormat:@"免费查看(%@)",[[PFUser currentUser] objectForKey:@"freeChance"]] forState:UIControlStateNormal];
        }
    }
    
    return view;
}

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
