//
//  ArticleDetailViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-5-24.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ICUTemplateMatcher.h"
#import <RESideMenu/RESideMenu.h>

@interface ArticleDetailViewController ()

@property (strong,nonatomic) NSString *htmlContent;
@property (weak, nonatomic) IBOutlet UIWebView *htmlWebView;


- (IBAction)showMenu:(id)sender;

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
    [self getHtmlFromParse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showMenu:(id)sender {
    
    [self.sideMenuViewController presentMenuViewController];
}

- (void)getHtmlFromParse{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Article"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"html"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.htmlContent = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
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
    
    
    NSString * content = @"\n                        <p><a class=\"img-link\" href=\"http://sex.guokr.com/image/w6wEenedgUqmMhJnJPMeBYExXTmsJNjCt3MX1A1W21BoAQAAEAEAAEpQ.jpg?id=1049207\" target=\"_blank\"><img class=\"img-responsive\" src=\"http://img1.guokr.com/image/w6wEenedgUqmMhJnJPMeBYExXTmsJNjCt3MX1A1W21BoAQAAEAEAAEpQ.jpg\" /></a></p>\n<p>\u5f53\u7814\u7a76\u8005\u63a2\u7a76\u6027\u884c\u4e3a\u7684\u65f6\u5019\uff0c\u4ed6\u4eec\u5e38\u5e38\u4f1a\u5173\u6ce8\u8c01\u624d\u662f\u6700\u6ee5\u4ea4\u7684\u4eba\u2014\u2014\u4f8b\u5982\uff0c\u4e0e\u987a\u4ece\u578b\u4eba\u683c\u7684\u4eba\u76f8\u6bd4\uff0c\u90a3\u4e9b\u652f\u914d\u578b\u4eba\u683c\u7684\u7537\u5973\u4f1a\u548c\u66f4\u591a\u7684\u4eba\u53d1\u751f\u5173\u7cfb\u3002[1]\u4f46\u201c\u4ec0\u4e48\u65f6\u5019\u7684\u6211\u4eec\u662f\u6700\u6ee5\u4ea4\u7684\u201d\u4e5f\u662f\u4e2a\u540c\u6837\u6709\u8da3\u7684\u95ee\u9898\uff1a\u4e00\u5e74365\u5929\uff0c\u6211\u4eec\u6700\u8822\u8822\u6b32\u52a8\u7684\u662f\u54ea\u4e9b\u65e5\u5b50\u5462\uff1f\u4ee5\u524d\u7684\u7814\u7a76\u91c7\u7528\u7684\u6863\u6848\u8d44\u6599\uff08\u5982\u51fa\u751f\u8bb0\u5f55\u3001\u5b89\u5168\u5957\u9500\u552e\u989d\u7b49\uff09\u663e\u793a\uff0c\u7f8e\u56fd\u7684\u6027\u884c\u4e3a\u5448\u73b0\u51fa\u4e00\u4e2a\u4e3a\u671f\u534a\u5e74\u7684\u5b63\u8282\u6027\u5faa\u73af\u7684\u73b0\u8c61\u3002\u4eba\u4eec\u4f3c\u4e4e\u6700\u4e50\u4e8e\u5728\u51ac\u5b63\u548c\u590f\u5b63\u540c\u8c10\u9c7c\u6c34\u4e4b\u6b22\uff0c\u5171\u6548\u4e8e\u98de\u4e4b\u613f\u3002[2][3]</p>\n<p>\u7ef4\u62c9\u8bfa\u74e6\u5927\u5b66\u5fc3\u7406\u5b66\u7cfb\u7684\u526f\u6559\u6388\u9a6c\u57fa\uff08Dr. Patrick M. Markey\uff09\u60f3\u91c7\u53d6\u65b0\u7684\u529e\u6cd5\u800c\u53c8\u66f4\u76f4\u63a5\u5730\u5904\u7406\u8fd9\u4e2a\u7814\u7a76\u95ee\u9898\u3002\u4ed6\u4eec\u4e0d\u60f3\u4f9d\u8d56\u6863\u6848\u7684\u51fa\u751f\u8bb0\u5f55\uff0c\u56e0\u4e3a\u8fd9\u4e5f\u8bb8\u4e0d\u80fd\u771f\u5b9e\u5730\u6355\u6349\u5230\u4eba\u4eec\u60f3\u7f20\u7ef5\u4eb2\u5bc6\u7684\u65f6\u523b\uff08\u6bd5\u7adf\uff0c\u6211\u4eec\u8fd8\u6709\u8282\u80b2\u907f\u5b55\u8fd9\u4e8b\u513f\uff09\u3002\u540c\u6837\u7684\uff0c\u5b89\u5168\u5957\u9500\u552e\u989d\u4e5f\u672a\u5fc5\u80fd\u51c6\u786e\u53cd\u6620\u4eba\u4eec\u5230\u5e95\u5728\u4ec0\u4e48\u65f6\u5019\u4f7f\u7528\u4e86\u6240\u8d2d\u4e70\u7684\u5957\u5957\u3002\u800c\u76f4\u63a5\u95ee\u4eba\u4eec\u8bb0\u4e0d\u8bb0\u5f97\u4ed6\u4eec\u4ec0\u4e48\u65f6\u5019\u201c\u60f3\u505a\u201d\u4e5f\u56f0\u96be\u91cd\u91cd\uff0c\u56e0\u4e3a\u4eba\u4eec\u4e0d\u4f1a\u603b\u662f\u8bb0\u5f97\u4ed6\u4eec\u5bfb\u6b22\u7684\u65f6\u95f4\u548c\u65e5\u671f\uff08\u79d1\u5b66\u5bb6\u79f0\u4e4b\u4e3a\u201c\u56de\u987e\u6027\u8bb0\u5fc6\u504f\u5dee\u201d\uff09\u3002</p>\n<p>\u597d\u5728\uff0c\u8fd8\u6709\u53e6\u4e00\u4e2a\u9014\u5f84\u53bb\u63a2\u7a76\u4eba\u4eec\u5728\u67d0\u4e00\u7279\u5b9a\u65f6\u95f4\u6bb5\u7684\u6027\u6b32\u5f3a\u70c8\u7a0b\u5ea6\uff0c\u90a3\u5c31\u662f\u8bc4\u4f30\u4e92\u8054\u7f51\u4e0a\u5173\u952e\u8bcd\u641c\u7d22\u7684\u53d8\u5316\u3002\u4fe1\u606f\u65f6\u4ee3\uff0c\u53ea\u9700\u8f7b\u6572\u952e\u76d8\uff0c\u8c37\u6b4c\u5ea6\u5a18\u4fbf\u4f1a\u4e3a\u4f60\u4e00\u4e00\u5448\u732e\u5404\u79cd\u4e3b\u9898\u7684\u8d44\u8baf\uff08\u6027\u4e3b\u9898\u5f53\u7136\u4e5f\u5728\u5176\u4e2d\uff09\u3002\u8b6c\u5982\uff0c\u5982\u679c\u67d0\u8001\u7f8e\u60f3\u627e\u8272\u60c5\u5f71\u7247\u65f6\uff0c\u4ed6\u4f1a\u5728\u641c\u7d22\u5f15\u64ce\u91cc\u8f93\u5165\u201cporn\u201d\uff08porn\u610f\u4e3a\u8272\u60c5\u7247\uff09\u8fd9\u4e2a\u8bcd\uff1b\u5982\u679c\u4ed6\u60f3\u7ea6\u4e2a\u70ae\u53cb\u6216\u662f\u53eb\u4e2a\u5e94\u53ec\u5973\u90ce\u3001\u53c8\u6216\u662f\u4ed6\u60f3\u52a0\u5165\u5230\u4e00\u573a\u4e0d\u6b63\u5f53\u7684\u6027\u884c\u4e3a\u4e2d\u53bb\u65f6\uff0c\u4ed6\u53ef\u80fd\u5c31\u4f1a\u8f93\u5165\u201ceHarmony\u201d\uff08eHarmony\u4e3a\u4e00\u56fd\u5916\u5a5a\u604b\u4ea4\u53cb\u7f51\u7ad9\uff09\u3002</p>\n<p>\u56e0\u6b64\uff0c\u4e3a\u4e86\u66f4\u51c6\u786e\u5730\u5b9a\u4f4d\u90a3\u8822\u52a8\u7684\u5b63\u8282\uff0c\u4ed6\u4eec\u8c03\u67e5\u4e86\u8fc7\u53bb5\u5e74\u95f4\u4e92\u8054\u7f51\u4e0e\u8272\u60c5\u7247\u3001\u53ec\u5993\u3001\u7ea6\u70ae\u7b49\u4e3b\u9898\u7684\u5173\u952e\u8bcd\u641c\u7d22\u3002[4]\u5229\u7528\u8c37\u6b4c\u63d0\u4f9b\u7684\u3001\u4ee3\u8868\u6570\u767e\u4e07\u7f51\u7edc\u641c\u7d22\u7684\u6570\u636e\uff0c\u4ed6\u4eec\u68c0\u6d4b\u4e86\u5404\u79cd\u5404\u6837\u7684\u5173\u952e\u8bcd\uff0c\u5305\u62ec\u6709\uff1a\u8272\u60c5\u7247\u4e3b\u9898\u5173\u952e\u8bcd\uff0c\u5982\u201cporn\u201d\u3001\u201cxvideos\u201d\uff08\u5373\u201c\u7231\u60c5\u52a8\u4f5c\u5927\u7247\u201d\uff09\uff1b\u62db\u5993\u4e3b\u9898\u5173\u952e\u8bcd\uff0c\u5982\u201ccall girl\u201d\uff08\u5e94\u53ec\u5973\u90ce\u3001\u56e1\u56e1\uff08\u6e2f\u6fb3\uff09\uff09\u3001\u201cescort\u201d\uff08\u610f\u4e3a\u53d7\u96c7\u966a\u540c\u67d0\u4eba\u5916\u51fa\u793e\u4ea4\u7684\u4eba\uff0c\u63f4\u4ea4\uff09\uff1b\u7ea6\u70ae\u4e3b\u9898\u5173\u952e\u8bcd\uff0c\u5982\u201ceHarmony\u201d\u3001\u201cMatch.com\u201d\uff08\u56fd\u5916\u77e5\u540d\u5a5a\u604b\u4ea4\u53cb\u7f51\u7ad9\uff09\u3002</p>\n<p>\u7ecf\u8fc7\u5206\u6790\uff0c\u4ed6\u4eec\u53d1\u73b0\uff0c\u51ac\u5b63\u548c\u521d\u590f\u662f\u8fd9\u4e9b\u5173\u952e\u8bcd\u51fa\u73b0\u7684\u9ad8\u5cf0\u671f\uff0c\u5448\u73b0\u51fa\u4e00\u4e2a\u6e05\u6670\u8fde\u7eed\u7684\u4e3a\u671f\u534a\u5e74\u7684\u5468\u671f\u6027\u5faa\u73af\u3002\u6709\u8da3\u7684\u662f\uff0c\u5bf9\u4e8e\u90a3\u4e9b\u4e0e\u6027\u4e3b\u9898\u65e0\u5173\u7684\u5173\u952e\u8bcd\u641c\u7d22\uff08\u5982\u4e0e\u6c7d\u8f66\u96f6\u4ef6\u3001\u5ba0\u7269\u6709\u5173\u7684\u5173\u952e\u8bcd\uff09\uff0c\u4ed6\u4eec\u5e76\u6ca1\u6709\u53d1\u73b0\u7c7b\u4f3c\u7684\u534a\u5e74\u671f\u8d8b\u52bf\u2014\u2014\u8fd9\u610f\u5473\u7740\u8fd9\u4e2a\u5b63\u8282\u6027\u8d8b\u52bf\u662f\u4e3a\u6027\u4e3b\u9898\u5173\u952e\u8bcd\u641c\u7d22\u6240\u72ec\u6709\u7684\u3002</p>\n<p>\u8fd9\u4e9b\u53d1\u8868\u5728\u300a\u6027\u884c\u4e3a\u6863\u6848\u300b\uff08Archives of Sexual Behavior\uff09\u4e0a\u7684\u7814\u7a76\u7ed3\u679c\uff0c\u4e0e\u8fc7\u53bb\u7684\u5229\u7528\u6863\u6848\u6570\u636e\uff08\u5982\u51fa\u751f\u8bb0\u5f55\u3001\u5b89\u5168\u5957\u9500\u552e\u989d\u7b49\uff09\u7814\u7a76\u6027\u6b32\u671b\u7684\u5b63\u8282\u6027\u8d8b\u52bf\u7684\u7814\u7a76\u7ed3\u679c\u76f8\u7b26\u3002\u7814\u7a76\u663e\u793a\uff0c\u5728\u7f8e\u56fd\uff0c\u4eba\u4eec\u5728\u51ac\u5b63\u548c\u590f\u5b63\u6027\u6b32\u671b\u7684\u6c34\u5e73\u66f4\u9ad8\u3002</p>\n<p>\u867d\u7136\u8fd9\u4e2a\u5b63\u8282\u6027\u6ce2\u52a8\u80cc\u540e\u7684\u5177\u4f53\u539f\u56e0\u5c1a\u4e0d\u660e\u786e\uff0c\u4f46\u8fd9\u4e2a\u53d1\u73b0\u4ecd\u7136\u5341\u5206\u5b9e\u7528\u3002\u6b63\u5982\u9884\u9632\u9189\u9a7e\u7684\u5ba3\u4f20\u6d3b\u52a8\uff0c\u5e94\u7784\u51c6\u5728\u5723\u8bde\u8282\u65b0\u5e74\u5047\u671f\u5f00\u5c55\uff0c\u56e0\u4e3a\u8fd9\u6bb5\u65f6\u95f4\u662f\u9189\u9a7e\u4e8b\u6545\u9ad8\u53d1\u671f\uff0c\u4e3a\u5927\u5b66\u751f\u5f00\u8bbe\u7684\u5b89\u5168\u6027\u884c\u4e3a\u9879\u76ee\u53ef\u4ee5\u7784\u51c6\u5728\u79cb\u5b63\u5b66\u671f\uff08\u51ac\u5b63\u6027\u6b32\u9ad8\u5cf0\u671f\u51fa\u73b0\u4e4b\u524d\uff09\u548c\u6625\u5b63\u5b66\u671f\uff08\u590f\u5b63\u6027\u6b32\u9ad8\u5cf0\u671f\u51fa\u73b0\u4e4b\u524d\uff09\u6765\u5f00\u5c55\u3002\u6bd5\u7adf\uff0c\u5728\u5b66\u751f\u4eec\u5927\u641e\u7279\u641e\u4e4b\u524d\uff0c\u5f00\u5c55\u5b89\u5168\u6027\u884c\u4e3a\u5ba3\u4f20\u8fd0\u52a8\u786e\u5b9e\u662f\u5f88\u5408\u7406\u7684\u3002</p>\n<p>PS\uff1a\u636e\u6027\u60c5\u541b\u7684\u731c\u60f3\uff0c\u9020\u6210\u8fd9\u4e2a\u73b0\u8c61\u7684\u539f\u56e0\u6050\u6015\u662f\uff0c\u590f\u5929\u7a7f\u5f97\u592a\u5c11\uff0c\u51ac\u5929\u5b85\u5f97\u592a\u591a~~~</p>\n<p>\u76f8\u5173\u5c0f\u7ec4\uff1a</p>\n<p><a href=\"http://www.guokr.com/group/30/\" target=\"_blank\">\u6027\u60c5</a>  </p>\n<p><a href=\"http://www.guokr.com/group/127/\" target=\"_blank\">\u60c5\u611f\u591c\u591c\u8bdd</a>  </p>\n<p>\u672c\u6587\u7f16\u8bd1\u81ea\uff1a</p>\n<p><a href=\"http://www.scienceofrelationships.com/home/2012/8/7/the-seasons-for-sex.html\" target=\"_blank\">Science of Relationships - | - The Seasons for\u00a0Sex</a>  </p>\n<p>\u76f8\u5173\u53c2\u8003\u6587\u732e</p>\n<p>[1]Markey, P. M., & Markey, C. N. (2007).\u00a0 The interpersonal meaning of sexual promiscuity. Journal of Research in Personality, 41, 1199-1212.</p>\n<p>[2]Levin, M. L., Xu, X., & Bartkowski, J. P. (2002). Seasonality of sexual debut. Journal of Marriage and Family, 64, 871-884.</p>\n<p>[3]Seiver, D. A. (1985). Trend and variation in the seasonality of U.S. fertility, 1947\u20131976. Demography, 22, 89-100.\u3001</p>\n<p>[4]Markey, P. M., & Markey, C. N. (2012). Seasonal variation in internet keyword searches: A proxy assessment of sex mating behaviors. Archives of Sexual Behavior. doi: 10.1007/s10508-012-9996-5</p>\n<p>\u4f5c\u8005\u4fe1\u606f\uff1a</p>\n<p><a href=\"http://rutgers university :: charlotte markey, ph.d. http://markey.rutgers.edu/\" target=\"_blank\">Dr. Charlotte Markey</a>  </p>\n<p><a href=\"http://interpersonalresearch.weebly.com/dr-patrick-markey.html\" target=\"_blank\">Dr. Patrick Markey</a>  </p>\n<p></p>\n                    ";
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
