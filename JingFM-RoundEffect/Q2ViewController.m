//
//  Q2ViewController.m
//  MagicOpener
//
//  Created by wenlin on 13-10-12.
//  Copyright (c) 2013年 isaced. All rights reserved.
//

#import "Q2ViewController.h"

@interface Q2ViewController (){
    
    PFFile * screenshot;
    MBProgressHUD *hud;
    
}
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;

- (IBAction)saveFeedback:(id)sender;

@end

@implementation Q2ViewController

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
    
    _emailLabel.text = [[PFUser currentUser] objectForKey:@"email"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    
    [_screenshotImageView addGestureRecognizer:tap];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _uploadLabel.layer.cornerRadius = 5.0;
    _uploadLabel.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5.0;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.hidden = YES;
    if (screenshot) {
        _submitButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _uploadLabel.hidden = YES;
    NSData *imgData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1f);
    
    [_screenshotImageView setImage:[UIImage imageWithData:imgData]];
    screenshot = [PFFile fileWithData:imgData];
    
    [screenshot saveInBackground];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (IBAction)saveFeedback:(id)sender {
    

    
    if (screenshot) {
        
        //hud & Timer
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        [hud show:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
        
        
        PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
        [feedback setObject:@2 forKey:@"questionId"];
        [feedback setObject:screenshot forKey:@"screenshot"];
        [feedback setObject:[PFUser currentUser] forKey:@"fromUser"];
        [feedback setObject:[[PFUser currentUser] objectForKey:@"email"] forKey:@"email"];
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [timer invalidate];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"成功提交";
                [hud hide:YES afterDelay:2];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"网络连接问题,请稍后再试"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
                
            }
        }];
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                      message:@"截图为空"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    
    }
}


- (void)handleHudTimeout{
    
    hud.mode = MBProgressHUDModeText;
	hud.labelText = @"网络连接有问题";
    [hud hide:YES afterDelay:3];
}

@end
