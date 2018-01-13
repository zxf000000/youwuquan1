//
//  XFVideoMoreCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFNetworkImageNode.h"
#import "XFVideoModel.h"

@interface XFVideoMoreSubCell : ASCellNode

@property (nonatomic,strong) XFNetworkImageNode *picNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASTextNode *numberNode;

@property (nonatomic,strong) XFVideoModel *model;

- (instancetype)initWithModel:(XFVideoModel *)model;

@end

@interface XFVideoMoreCell : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) XFNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASButtonNode *followButton;

@property (nonatomic,strong) ASTextNode *moreNode;

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,copy) NSDictionary *allinfo;

- (instancetype)initWithInfo:(NSDictionary *)info;

@property (nonatomic,copy) void(^clickFollowButtonBlock)(ASButtonNode *button);

- (void)setColl;

@end
