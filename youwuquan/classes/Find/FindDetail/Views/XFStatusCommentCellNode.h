//
//  XFStatusCommentCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFCommentModel.h"
#import "XFNetworkImageNode.h"

@class XFStatusCommentCellNode;

@protocol XFStatusCommentDelegate <NSObject>

- (void)statusCommentNode:(XFStatusCommentCellNode *)commentNode didClickComplyTextWithIndex:(NSIndexPath *)indexPath;

@end

@interface XFStatusCommentCellNode : ASCellNode

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) XFNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *timeNode;

@property (nonatomic,strong) ASTextNode *commentNode;

@property (nonatomic,strong) ASDisplayNode *lineNode;

@property (nonatomic,strong) XFCommentModel *model;

@property (nonatomic,strong) id <XFStatusCommentDelegate> delegate;

- (instancetype)initWithMode:(XFCommentModel *)model;

@end
