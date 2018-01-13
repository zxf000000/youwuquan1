//
//  XFNetworkImageNode.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/11.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFNetworkImageNode : ASDisplayNode

@property (nonatomic,strong) UIColor *placeholderColor;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSURL *url;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask;

@end
