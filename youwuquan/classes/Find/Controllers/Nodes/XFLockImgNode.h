//
//  XFLockImgNode.h
//  youwuquan
//
//  Created by mr.zhou on 2018/3/8.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFLockImgNode : ASDisplayNode
@property (nonatomic,strong) ASImageNode *imgNode;
@property (nonatomic,strong) ASTextNode *titleNode;
@property (nonatomic,strong) XFNetworkImageNode *bgNode;

- (instancetype)initWithNumber:(NSInteger)number img:(NSString *)urlStr;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask;
@end
