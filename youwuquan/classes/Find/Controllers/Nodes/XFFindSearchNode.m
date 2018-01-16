//
//  XFFindSearchNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/15.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFFindSearchNode.h"

@implementation XFFindSearchNode

- (instancetype)init {
    
    if (self = [super init]) {
      
        self.backgroundColor = UIColorHex(f4f4f4);
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.cornerRadius = 5;
        
        [self addSubnode:_bgNode];
        
        _searchButton = [[ASButtonNode alloc] init];
        [_searchButton setImage:[UIImage imageNamed:@"find_search"] forState:(UIControlStateNormal)];
        [_searchButton setTitle:@"搜索" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self addSubnode:_searchButton];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _bgNode.style.preferredSize = CGSizeMake(293, 21);
    _searchButton.style.preferredSize = CGSizeMake(50, 21);
    ASInsetLayoutSpec *insetButton = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 5, 0, 293 - 50 - 5)) child:_searchButton];
    ASOverlayLayoutSpec *overlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_bgNode overlay:insetButton];
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, (kScreenWidth - 293)/2, 10, (kScreenWidth - 293)/2)) child:overlay];
    
    return inset;
    
}

@end
