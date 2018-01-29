//
//  XFCommentMessageTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFCommentMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasPicConstain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasNoPicContrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomContrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBottomContrains;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
