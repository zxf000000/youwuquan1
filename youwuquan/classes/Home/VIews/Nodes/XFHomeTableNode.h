//
//  XFHomeTableNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class XFHomeTableNode;

@protocol XFHomeNodedelegate <NSObject>

- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath;

- (void)homeNode:(XFHomeTableNode *)node didClickIconWithindex:(NSIndexPath *)indexPath;

@end

@interface XFHomeTableNode : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *picNode;

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,copy) NSArray *authenticationIcons;

@property (nonatomic,strong) ASButtonNode *likeNode;

@property (nonatomic,strong) ASImageNode *shadowNode;

@property (nonatomic,strong) ASTextNode *priceNode;

@property (nonatomic,assign) BOOL isBig;

@property (nonatomic,strong) id <XFHomeNodedelegate> delegate;


@end
