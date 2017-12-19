//
//  ASSearchManCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFSearchManCollectioNCell : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@end

@interface ASSearchManCellNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,copy) void (^didSelecSearchMan)(void);

@end
