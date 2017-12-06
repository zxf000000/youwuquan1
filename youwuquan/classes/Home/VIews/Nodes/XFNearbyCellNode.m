//
//  XFNearbyCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNearbyCellNode.h"

@implementation XFNearbyCellNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _bgNode = [[ASDisplayNode alloc] init];
        
        _bgNode.backgroundColor = [UIColor whiteColor];
        [_bgNode setShadowColor:UIColorHex(e0e0e0).CGColor];
        [_bgNode setShadowRadius:4];
        [_bgNode setShadowOpacity:0.5];
        [_bgNode setShadowOffset:(CGSizeMake(0, 0))];
        
        _bgNode.cornerRadius = 4;
        
        [self addSubnode:_bgNode];
        
        _iconNode = [[ASNetworkImageNode alloc] init];
        
        [_iconNode setDefaultImage:[UIImage imageNamed:@"zhanweitu44"]];
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        [_nameNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(868383) offset:0 text:kRandomName lineSpace:2 kern:0];
        
        [self addSubnode:_nameNode];
        
        _distanceButton = [[ASButtonNode alloc] init];
        
        [_distanceButton setImage:[UIImage imageNamed:@"home_location"] forState:(UIControlStateNormal)];
        
        [_distanceButton setTitle:@"0.66km" withFont:[UIFont systemFontOfSize:12] withColor:UIColorHex(f72f5e) forState:(UIControlStateNormal)];
        
        [self addSubnode:_distanceButton];
        
//        self.backgroundColor = [UIColor redColor];
        
        

    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _iconNode.style.preferredSize = CGSizeMake(62, 62);
    
    _iconNode.style.spacingBefore = 0;
    _nameNode.style.spacingBefore = 15;
    _distanceButton.style.spacingBefore = 8;
    
    _iconNode.style.flexGrow = YES;

    ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,_nameNode,_distanceButton]];
    
    alllayout.style.flexGrow = YES;
    
    ASInsetLayoutSpec *allInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(17, 12, 17, 12)) child:alllayout];
    
    ASOverlayLayoutSpec *overLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_bgNode overlay:allInset];
    
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(17, 5, 17, 5)) child:overLay];
}

@end
