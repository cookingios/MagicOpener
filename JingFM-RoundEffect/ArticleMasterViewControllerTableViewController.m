//
//  ArticleMasterViewControllerTableViewController.m
//  MagicOpener
//
//  Created by wenlin on 14-8-17.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ArticleMasterViewControllerTableViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "ArticleCell.h"
#import "LoadMoreCell.h"

@interface ArticleMasterViewControllerTableViewController ()

@property (strong,nonatomic) PFObject *currentArticle;

- (IBAction)showMeny:(id)sender;

@end

@implementation ArticleMasterViewControllerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom initialization
        self.parseClassName = @"Article";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        self.loadingViewEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable{

    PFQuery *query = [PFQuery queryWithClassName:@"Article"];
    [query whereKey:@"available" equalTo:[NSNumber numberWithBool:YES]];
    [query orderByDescending:@"createdAt"];
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 3;
    return query;


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Article"];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Article"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMeny:(id)sender {
    
    [self.sideMenuViewController presentMenuViewController];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.sourceLabel.text = object[@"source"];
    cell.titleLabel.text = object[@"title"];
    cell.authorLabel.text = [NSString stringWithFormat:@"作者:%@",object[@"author"]];
    cell.editorsPicksIconImageView.hidden = (![(NSNumber*)object[@"isEditorsPicks"] boolValue]);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( [self.objects count]>indexPath.row || (![self.objects count]==indexPath.row )) {
        
        self.currentArticle = self.objects[indexPath.row];
        
        NSDictionary *dict = @{@"title":self.currentArticle[@"title"]};
        [MobClick event:@"DuplicateOpener" attributes:dict];

        [self performSegueWithIdentifier:@"ArticleDetailSegue" sender:self];
        
    }else{
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ArticleDetailSegue"]) {
        [dvc setValue:self.currentArticle[@"html"] forKey:@"htmlContent"];
        [dvc setValue:self.currentArticle[@"title"] forKey:@"titleString"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *object = [self objectAtIndexPath:indexPath];
    
    if (object == nil) {
        // Return a fixed height for the extra ("Load more") row
        return 45;
    }else{
         return 75;
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        return nil;
    } else {
        return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    }
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"LoadMoreCell";
    
    LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

@end
