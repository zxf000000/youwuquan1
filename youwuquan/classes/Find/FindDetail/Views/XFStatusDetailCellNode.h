//
//  XFStatusDetailCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFStatusModel.h"
#import "XFLockNode.h"
@class XFNetworkImageNode;
@class XFStatusDetailCellNode;


@interface XFCloseImgNode : XFNetworkImageNode

@property (nonatomic,strong) XFLockNode *lockNode;

@end



@interface XFStatusDetailCollectionCellnode : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@end


@protocol XFStatusDetailCellDelegate

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didSelectedPicWithIndex:(NSInteger)index pics:(NSArray *)pics picnodes:(NSArray *)picNodes;

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickFollowButton:(ASButtonNode *)followButton;

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickLikeButton:(ASButtonNode *)followButton;

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickIconNode:(ASButtonNode *)iconNode;

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickVoiceNodeWithUrl:(NSString *)url;

@end


@interface XFStatusDetailCellNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>


- (instancetype)initWithImages:(NSArray *)images likeImgs:(NSArray *)likeImgs unlock:(BOOL)unlock;

- (instancetype)initWithModel:(XFStatusModel *)status likeDatas:(NSArray *)likeDatas;

@property (nonatomic,copy) NSArray *allImgs;
@property (nonatomic,copy) NSArray *likeIcons;

@property (nonatomic,strong) ASNetworkImageNode *iconNode;
@property (nonatomic,strong) ASTextNode *nameNode;
@property (nonatomic,strong) ASTextNode *timeNode;
@property (nonatomic,strong) ASButtonNode *followButton;

@property (nonatomic,strong) XFStatusModel *status;

@property (nonatomic,strong) ASButtonNode *playButton;
// 内容
@property (nonatomic,strong) ASTextNode *commentNode;

@property (nonatomic,copy) NSArray *images;

// 所有动态图片集合
@property (nonatomic,strong) NSMutableArray *imageNodes;

@property (nonatomic,strong) ASTextNode *numberNode;

@property (nonatomic,strong) ASButtonNode *likeNode;
@property (nonatomic,strong) ASButtonNode *contentNode;

@property (nonatomic,strong) ASDisplayNode *lineNode;

@property (nonatomic,strong) ASImageNode *likeImg;
@property (nonatomic,strong) NSArray *likeimgs;
@property (nonatomic,strong) NSArray *likeimgNodes;

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,strong) id <XFStatusDetailCellDelegate> detailDelegate;

@property (nonatomic,assign) BOOL isUnlock;

// 语音
@property (nonatomic,strong) ASButtonNode *voiceButton;
@property (nonatomic,strong) ASTextNode *voiceTimeNode;

@end
