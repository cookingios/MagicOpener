//
//  ArticleCell.h
//  MagicOpener
//
//  Created by wenlin on 14-8-17.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <Parse/Parse.h>

@interface ArticleCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editorsPicksIconImageView;

@end
