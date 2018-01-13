//
//  XFHomeTableNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFHomeDataModel.h"
#import "XFNetworkImageNode.h"
@class XFHomeTableNode;

@protocol XFHomeNodedelegate <NSObject>

- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath;

- (void)homeNode:(XFHomeTableNode *)node didClickIconWithindex:(NSIndexPath *)indexPath;

@end

@interface XFHomeTableNode : ASCellNode

@property (nonatomic,strong) XFNetworkImageNode *picNode;

@property (nonatomic,strong) XFNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,copy) NSArray *authenticationIcons;

@property (nonatomic,strong) ASButtonNode *likeNode;

@property (nonatomic,strong) ASImageNode *shadowNode;

@property (nonatomic,strong) ASTextNode *priceNode;

@property (nonatomic,assign) BOOL isBig;

@property (nonatomic,strong) XFHomeDataModel *model;

@property (nonatomic,strong) id <XFHomeNodedelegate> delegate;

- (instancetype)initWithModel:(XFHomeDataModel *)model;

@end
