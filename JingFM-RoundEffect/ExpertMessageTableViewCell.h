//
//  ExpertMessageTableViewCell.h
//  MagicOpener
//
//  Created by wenlin on 14-5-27.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
