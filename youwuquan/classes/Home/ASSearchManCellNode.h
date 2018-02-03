//
//  ASSearchManCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class XFSearchUserModel;
@interface XFSearchManCollectioNCell : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) XFSearchUserModel *model;

@end

@interface ASSearchManCellNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,copy) void (^didSelecSearchMan)(XFSearchUserModel *model);

@property (nonatomic,copy) NSArray *datas;

- (instancetype)initWithDatas:(NSArray *)datas;

@end
