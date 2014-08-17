//
//  ArticleDetailViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-5-24.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ICUTemplateMatcher.h"

@interface ArticleDetailViewController ()

@property (strong,nonatomic) NSString *htmlContent;
@property (weak, nonatomic) IBOutlet UIWebView *htmlWebView;





@end

@implementation ArticleDetailViewController

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

@end
