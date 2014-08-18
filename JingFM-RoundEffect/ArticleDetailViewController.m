//
//  ArticleDetailViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-5-24.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ICUTemplateMatcher.h"
#import <ShareSDK/ShareSDK.h>


@interface ArticleDetailViewController ()

@property (strong,nonatomic) NSString *htmlContent;
@property (weak, nonatomic) IBOutlet UIWebView *htmlWebView;
@property (strong,nonatomic) NSString *titleString;

- (IBAction)shareArticle:(id)sender;


@end

@implementation ArticleDetailViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
    }
    return self;
}


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
    //[self configWebView];
    [self.htmlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlContent]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getHtmlFromParse{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Article"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 60;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"html"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.htmlContent =[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                NSLog(@"html is %@",self.htmlContent);
                NSLog(@"url is %@",file.url);
                [self.htmlWebView loadHTMLString:self.htmlContent baseURL:nil];
            }];
        }
    }];
    
}

- (void)configWebView{
    
    // Set up template engine with your chosen matcher.
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    //[engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    
    NSString * content = @"";
    NSString *result = [MOUtility replaceUnicode:content];
    [engine setObject:@"Hello Engine" forKey:@"title"];
    [engine setObject:result forKey:@"content"];
    
    // MGTemplateEngine/Detail/detail.html
    // MGTemplateEngine/Detail/detail.css
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
    
    // Process the template and display the results.
    NSString *html = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    
    
    // 获得HTML
    self.htmlWebView.delegate = self;
    //self.htmlWebView.userInteractionEnabled = NO;
    
    // 你就能加载到HTML里面的.css文件
    NSString *baseURL = [[NSBundle mainBundle] resourcePath];
    [self.htmlWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:baseURL]];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareArticle:(id)sender {
    
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeWeixiFav,ShareTypeYouDaoNote,ShareTypeEvernote,ShareTypeMail,nil];
    
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo100" ofType:@"png"];
    NSString *content = [NSString stringWithFormat:@"约会助手:%@",self.titleString];
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:content
                                                  url:self.htmlContent
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:_appDelegate.viewDelegate
                                                      friendsViewDelegate:_appDelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
@end
