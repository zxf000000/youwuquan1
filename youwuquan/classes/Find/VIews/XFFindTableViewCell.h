//
//  XFFindTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XFFindLayout.h"
//#import "YYTableViewCell.h"
@class XFFindTableViewCell;
@protocol WBStatusCellDelegate;


@interface WBStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic,strong) UIButton *shareButton;
//@property (nonatomic, assign) WBUserVerifyType verifyType;
@property (nonatomic, weak) XFFindTableViewCell *cell;
@end

@interface WBStatusToolbarView : UIView
@property (nonatomic, strong) UIButton *dsButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;


@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, weak) XFFindTableViewCell *cell;

- (void)setWithLayout:(XFFindLayout *)layout;
// set both "liked" and "likeCount"
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;
@end




@interface WBStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) WBStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    //转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本
@property (nonatomic, strong) WBStatusToolbarView *toolbarView; // 工具栏
@property (nonatomic, strong) UIImageView *vipBackgroundView;   // VIP 自定义背景
@property (nonatomic, strong) UIButton *menuButton;             // 菜单按钮
@property (nonatomic, strong) UIButton *followButton;           // 关注按钮

@property (nonatomic, strong) XFFindLayout *layout;
@property (nonatomic, weak) XFFindTableViewCell *cell;
@end



@protocol WBStatusCellDelegate;
@interface XFFindTableViewCell : UITableViewCell
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
@property (nonatomic, strong) WBStatusView *statusView;
- (void)setLayout:(XFFindLayout *)layout;
@end



@protocol WBStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(XFFindTableViewCell *)cell;
/// 点击了 Card
- (void)cellDidClickCard:(XFFindTableViewCell *)cell;
/// 点击了转发内容
- (void)cellDidClickRetweet:(XFFindTableViewCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(XFFindTableViewCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(XFFindTableViewCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(XFFindTableViewCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(XFFindTableViewCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(XFFindTableViewCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(XFFindTableViewCell *)cell;
/// 点击了用户
//- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user;
/// 点击了图片
- (void)cell:(XFFindTableViewCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(XFFindTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end
