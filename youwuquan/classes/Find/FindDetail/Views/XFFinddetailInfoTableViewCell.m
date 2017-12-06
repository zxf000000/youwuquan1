//
//  XFFinddetailInfoTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFinddetailInfoTableViewCell.h"

@implementation XFFinddetailInfoTableViewCell

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = kBgGrayColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.shadowColor = UIColorHex(808080).CGColor;
        _bgNode.shadowOffset = CGSizeMake(0, 0);
        _bgNode.shadowOpacity = 0.5;
        _bgNode.backgroundColor = [UIColor whiteColor];
        
        _heightNode = [[ASTextNode alloc] init];
        [_heightNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"身高" lineSpace:2 kern:0];
        _wightNode = [[ASTextNode alloc] init];
        [_wightNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"体重" lineSpace:2 kern:0];
        _swNode = [[ASTextNode alloc] init];
        [_swNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"三围" lineSpace:2 kern:0];
        
        _heiNUmberNode = [[ASTextNode alloc] init];
        [_heiNUmberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"197CM" lineSpace:2 kern:0];
        _wightNumberNode = [[ASTextNode alloc] init];
        [_wightNumberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"98KG" lineSpace:2 kern:0];
        _swNumberNode = [[ASTextNode alloc] init];
        [_swNumberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"90/80/99" lineSpace:2 kern:0];
        
        // 简介
        _desNode = [[ASTextNode alloc] init];
        [_desNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"简介" lineSpace:2 kern:0];
        _desDetailNode = [[ASTextNode alloc] init];
        [_desDetailNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:UIColorHex(808080) offset:0 text:@"内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手内地男歌手" lineSpace:2 kern:2];
        [self addSubnode:_bgNode];
        [self addSubnode:_heightNode];
        [self addSubnode:_wightNode];
        [self addSubnode:_swNode];
        [self addSubnode:_heiNUmberNode];
        [self addSubnode:_wightNumberNode];
        [self addSubnode:_swNumberNode];
        [self addSubnode:_desDetailNode];
        [self addSubnode:_desNode];

    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
//    _heightNode.style.preferredSize = CGSizeMake(30, 20);
//    _heiNUmberNode.style.preferredSize = CGSizeMake(30, 20);
    
    _desNode.style.spacingBefore = 20;
    _desDetailNode.style.spacingBefore = 10;
    
    ASStackLayoutSpec *heightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_heightNode,_heiNUmberNode]];
    
    ASStackLayoutSpec *wightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_wightNode,_wightNumberNode]];
    
    ASStackLayoutSpec *swLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_swNode,_swNumberNode]];
    
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceAround) alignItems:(ASStackLayoutAlignItemsCenter) children:@[heightLayout,wightLayout,swLayout]];
    
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, kScreenWidth - 80)) child:_desNode];
    inset.style.spacingBefore = 20;
    
    // 简介
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upLayout,inset,_desDetailNode]];
    
    ASInsetLayoutSpec *allInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(15, 15, 20, 15)) child:allLayout];
    
    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:allInset background:_bgNode];
    
    ASInsetLayoutSpec *bgInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];


    return bgInset;
    
}

@end
