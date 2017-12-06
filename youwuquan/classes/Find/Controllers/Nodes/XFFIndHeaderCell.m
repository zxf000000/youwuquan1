//
//  XFFIndHeaderCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFIndHeaderCell.h"

@implementation XFFIndHeaderCell

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backNode = [[ASDisplayNode alloc] init];
        _backNode.backgroundColor = [UIColor whiteColor];
        _backNode.shadowColor = UIColorHex(808080).CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.5;
        
        _backNode.cornerRadius = 4;
        
        [self addSubnode:_backNode];
        
        _picNode = [[ASNetworkImageNode alloc] init];
        _picNode.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
        _picNode.cornerRadius = 4;
        _picNode.clipsToBounds = YES;
        
        [self addSubnode:_picNode];
        
        _titleNode = [[ASTextNode alloc] init];
        [_titleNode setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] alignment:(NSTextAlignmentCenter) textColor:[UIColor whiteColor] offset:0 text:@"遇见美好夜生活" lineSpace:0 kern:0];
        
        [self addSubnode:_titleNode];
        
        _desNode = [[ASTextNode alloc] init];
        [_desNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor whiteColor] offset:0 text:@"一颗躁动的心" lineSpace:0 kern:0];
        
        [self addSubnode:_desNode];
        
        _joinButton = [[ASButtonNode alloc] init];
        [_joinButton setTitle:@"立即参与" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        [_joinButton setImage:[UIImage imageNamed:@"find_Activetymore"] forState:(UIControlStateNormal)];
        _joinButton.imageAlignment = ASButtonNodeImageAlignmentEnd;
        [self addSubnode:_joinButton];
        
        _moreButton = [[ASButtonNode alloc] init];
        [_moreButton setTitle:@"查看更多" withFont:[UIFont systemFontOfSize:12] withColor:kMainRedColor forState:(UIControlStateNormal)];
        [_moreButton setTitle:@"收起" withFont:[UIFont systemFontOfSize:12] withColor:kMainRedColor forState:(UIControlStateSelected)];
        [_moreButton setImage:[UIImage imageNamed:@"圆角矩形16"] forState:(UIControlStateNormal)];

        [_moreButton setImage:[UIImage imageNamed:@"find_retract"] forState:(UIControlStateSelected)];
        _moreButton.imageAlignment = ASButtonNodeImageAlignmentEnd;
        [self addSubnode:_moreButton];
        
        [_moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
    }
    return self;
}

- (void)setIsOpen:(BOOL)isOpen {
    
    _isOpen = isOpen;
    
    if (isOpen) {
        
        self.moreButton.selected = YES;
        
    } else {
        
        self.moreButton.selected = NO;

        
    }
    
}

- (void)clickMoreButton {
    
    if (self.isOpen) {
        if ([self.delegate respondsToSelector:@selector(didClickNoMoreButton)]) {
            
            [self.delegate didClickNoMoreButton];
            
        }
    } else {
        
        if ([self.delegate respondsToSelector:@selector(didClickMoreButton)]) {
            
            [self.delegate didClickMoreButton];
            
        }
    }
    

    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _desNode.style.spacingBefore = 10;
    _joinButton.style.spacingBefore = 15;
    
    ASStackLayoutSpec *textLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_titleNode,_desNode,_joinButton]];
    
    
    ASInsetLayoutSpec *insetTop = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(19, 10, 0, 0)) child:textLayout];
    
    // 图片比例 24/71
    _picNode.style.preferredSize = CGSizeMake(kScreenWidth - 20, (kScreenWidth - 20)*24/71.f);
    
    ASOverlayLayoutSpec *overlayImage = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_picNode overlay:insetTop];
    
    // 背景
    
    if (self.isEnd) {
        
        _moreButton.style.spacingBefore = _moreButton.style.spacingAfter = 29;
        
        ASBackgroundLayoutSpec *backLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:overlayImage background:_backNode];

        ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[backLayout,_moreButton]];

        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(5, 10, 5, 10)) child:stackLayout];

    } else {
        
        ASBackgroundLayoutSpec *backLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:overlayImage background:_backNode];

        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(5, 10, 5, 10)) child:backLayout];

    }
    

    return nil;
    
    
}

@end
