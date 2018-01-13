//
//  XFVideoNameCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVideoNameCell.h"

@implementation XFVideoNameCell

- (instancetype)initWithInfo:(XFVideoModel *)info {
    
    if (self = [super init]) {
        
        _model = info;
        _nameNode = [[ASTextNode alloc] init];
        
        [_nameNode setFont:[UIFont systemFontOfSize:15] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.title lineSpace:2 kern:0];
        
        [self addSubnode:_nameNode];
        
        _playImgNode = [[ASImageNode alloc] init];
        _playImgNode.image = [UIImage imageNamed:@"icon_play"];
        [self addSubnode:_playImgNode];
        
        _numberNode = [[ASTextNode alloc] init];
        [_numberNode setFont:[UIFont systemFontOfSize:10] alignment:(NSTextAlignmentLeft) textColor:UIColorHex(808080) offset:0 text:[NSString stringWithFormat:@"已播放%@次",_model.viewNum] lineSpace:2 kern:0];
        
        [self addSubnode:_numberNode];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _numberNode.style.spacingBefore = 8.5;
    
    ASStackLayoutSpec *bottomLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_playImgNode,_numberNode]];
    
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:11 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,bottomLayout]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:allLayout];
    
}

@end
