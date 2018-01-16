//
//  XFUpImageNode.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/16.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFUpImageNode : ASDisplayNode

@property (nonatomic,strong) ASImageNode *imageNode;

@property (nonatomic,strong) ASTextNode *titleNode;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask;

@end
