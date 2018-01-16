//
//  XFLockNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/16.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFLockNode.h"

@implementation XFLockNode

- (instancetype)initWithNumber:(NSInteger)number {
    
    if (self = [super init]) {
        
        _imgNode = [[ASImageNode alloc] init];
        _imgNode.image = [UIImage imageNamed:@"find_lock"];
        [self addSubnode:_imgNode];
        
        _titleNode = [[ASTextNode alloc] init];
        [_titleNode setFont:[UIFont systemFontOfSize:10] alignment:(NSTextAlignmentCenter) textColor:[UIColor whiteColor] offset:0 text:[NSString stringWithFormat:@"解锁%zd张",number] lineSpace:0 kern:2];
        [self addSubnode:_titleNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:2 justifyContent:(ASStackLayoutJustifyContentCenter) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_imgNode,_titleNode]];
    
    return layout;
    
}

@end
