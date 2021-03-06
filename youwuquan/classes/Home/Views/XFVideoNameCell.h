//
//  XFVideoNameCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFVideoModel.h"

@interface XFVideoNameCell : ASCellNode

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASImageNode *playImgNode;

@property (nonatomic,strong) ASTextNode *numberNode;

- (instancetype)initWithInfo:(XFVideoModel *)info;

@property (nonatomic,strong) XFVideoModel *model;

@end
