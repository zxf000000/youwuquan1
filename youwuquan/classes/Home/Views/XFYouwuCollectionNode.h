//
//  XFYouwuCollectionNode.h
//  youwuquan
//
//  Created by mr.zhou on 2018/2/8.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFHomeDataModel.h"
@interface XFYouwuCollectionNode : ASCellNode

@property (nonatomic,strong) XFNetworkImageNode *imgNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) XFHomeDataModel *model;
@property (nonatomic,strong) NSMutableArray *iconsVIew;
- (instancetype)initWithModel:(XFHomeDataModel *)model;


@end
