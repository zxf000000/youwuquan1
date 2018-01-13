//
//  XFHomeVideoTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFInsertLabel.h"
#import "XFVideoModel.h"
@class XFHomeVideoTableViewCell;

@protocol XFHomeVideoCellDelegate <NSObject>

- (void)videoCell:(XFHomeVideoTableViewCell *)cell didClickIconWithjindexpath:(NSIndexPath *)indexpath;

@end

@interface XFHomeVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet XFInsertLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic,strong) XFVideoModel *model;

@property (nonatomic,strong) id <XFHomeVideoCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
