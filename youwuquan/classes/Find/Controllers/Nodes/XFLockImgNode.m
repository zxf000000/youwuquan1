//
//  XFLockImgNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/3/8.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFLockImgNode.h"

@implementation XFLockImgNode

- (instancetype)initWithNumber:(NSInteger)number img:(NSString *)urlStr {
    
    if (self = [super init]) {
        
        _bgNode = [[XFNetworkImageNode alloc] init];
        _bgNode.url = [NSURL URLWithString:urlStr];
        [self addSubnode:_bgNode];
        
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
    
    ASOverlayLayoutSpec *overlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_bgNode overlay:layout];

    return overlay;
    
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask {
    
    [_imgNode addTarget:target action:action forControlEvents:controlEventMask];
    [_titleNode addTarget:target action:action forControlEvents:controlEventMask];
    [_bgNode addTarget:target action:action forControlEvents:controlEventMask];

}


@end
