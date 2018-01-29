//
//  XFFindCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFStatusModel.h"
#import "XFNetworkImageNode.h"
@class XFMyStatusCellNode;

@protocol XFMyStatusCellDelegate <NSObject>

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen;

- (void)findCellNode:(XFMyStatusCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath;

- (void)findCellNode:(XFMyStatusCellNode *)node didClickIconForIndex:(NSIndexPath *)indexPath;

- (void)findCellNode:(XFMyStatusCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath;


@end


@interface XFMyStatusCellNode : ASCellNode <ASNetworkImageNodeDelegate>

/**
 背景(阴影)
 */
@property (nonatomic,strong) ASDisplayNode *backNode;

/**
 头像
 */
@property (nonatomic,strong) XFNetworkImageNode *iconNode;

/**
 昵称
 */
@property (nonatomic,strong) ASTextNode *nameNode;

/**
 认证的图标
 */
@property (nonatomic,copy) NSArray *rzIcons;

/**
 关注
 */
@property (nonatomic,strong) ASButtonNode *approveButton;

/**
 分享
 */
@property (nonatomic,strong) ASButtonNode *shareButton;

/**
 图片
 */
@property (nonatomic,strong) ASNetworkImageNode *picNode;

// 图片集合
@property (nonatomic,copy) NSArray *pics;

@property (nonatomic,copy) NSArray *picNodes;

/**
 文编
 */
@property (nonatomic,strong) ASTextNode *contentNode;
@property (nonatomic,strong) ASTextNode *allcontentNode;
@property (nonatomic,strong) ASTextNode *proContentNode;

/**
 打赏
 */
@property (nonatomic,strong) ASButtonNode *rewardButton;

/**
 更多
 */
@property (nonatomic,strong) ASButtonNode *moreButton;

/**
 文字遮罩
 */
@property (nonatomic,strong) ASImageNode *shadowNode;

/**
 线
 */
@property (nonatomic,strong) ASDisplayNode *lineNode;

/**
 发布时间
 */
@property (nonatomic,strong) ASTextNode *timeNode;

/**
 点赞
 */
@property (nonatomic,strong) ASButtonNode *likeButton;

/**
 文字
 */
@property (nonatomic,strong) ASButtonNode *commentButton;

/**
 图片遮罩
 */
@property (nonatomic,strong) ASImageNode *imgShadowNode;

/**
 认证图标
 */

@property (nonatomic,assign) NSInteger picCount;

// 声音
@property (nonatomic,strong) ASButtonNode *voiceButton;
@property (nonatomic,strong) ASTextNode *voiceTimeNode;

@property (nonatomic,strong) ASButtonNode *playButton;

@property (nonatomic,copy) NSArray *allImgs;


@property (nonatomic,copy) NSArray *authenticationIcons;

@property (nonatomic,strong) id <XFMyStatusCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *index;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,strong) XFStatusModel *model;

@property (nonatomic,assign) NSInteger openCount;
@property (nonatomic,assign) NSInteger closeCount;

@property (nonatomic,copy) NSArray *tagNodes;

@property (nonatomic,strong) ASButtonNode *moneyButton;
@property (nonatomic,strong) ASButtonNode *setbutton;

- (instancetype)initWithPics:(NSArray *)pics open:(BOOL)open model:(XFStatusModel *)model;
@end
