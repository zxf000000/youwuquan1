//
//  XFNearbyCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFNearbyCellNode : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASButtonNode *distanceButton;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@end
