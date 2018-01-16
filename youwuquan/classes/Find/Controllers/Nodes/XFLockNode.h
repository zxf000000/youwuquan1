//
//  XFLockNode.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/16.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFLockNode : ASDisplayNode

@property (nonatomic,strong) ASImageNode *imgNode;
@property (nonatomic,strong) ASTextNode *titleNode;

- (instancetype)initWithNumber:(NSInteger)number;

@end
