//
//  HistoryViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-7-25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "HistoryViewController.h"
#import "MOExpert.h"
#import "MessageView.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)AskQuestion:(id)sender;

@end

@implementation HistoryViewController

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
    //self.title = self.expert.name;
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled = YES;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    self.pageControl.numberOfPages = [self.dataSource count];
    self.avatarImageView.image = self.expert.avatarImage;
    self.descriptionLabel.text = [NSString stringWithFormat:@"  %@的往期精选问答",self.expert.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)AskQuestion:(id)sender {
    
    [self performSegueWithIdentifier:@"SelectQuestionTypeSegue" sender:self];
    
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

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(MessageView *)view
{
    if (!view)
    {
    	view = [[NSBundle mainBundle] loadNibNamed:@"messageView" owner:self options:nil][0];
        
    }
    if ([self.dataSource[index] isKindOfClass:[PFObject class]]) {
        view.questionLabel.text = [self.dataSource[index] objectForKey:@"problem"];
        view.answerLabel.text = [self.dataSource[index] objectForKey:@"reply"];
    }
    
    return view;
}

#pragma mark - swipeView delegate
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    /*
    if ([self.dataSource[0] isKindOfClass:[PFObject class]]) {
        PFObject *currentObject = self.dataSource[swipeView.currentItemIndex];
        NSString *starImageName = [MOUtility getImageNameByRate:[currentObject objectForKey:@"rate"]];
        _starImageView.image = [UIImage imageNamed:starImageName];
    }
    */
    self.pageControl.currentPage = swipeView.currentItemIndex;
    
}



 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     id dvc = segue.destinationViewController;
     if ([segue.identifier isEqualToString:@"SelectQuestionTypeSegue"]) {
         [dvc setValue:self.expert.userId forKey:@"toUserId"];
     }
     
 }


@end
