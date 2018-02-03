//
//  XFHomeTableNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeTableNode.h"


#define kCellHeight kScreenWidth * 38 / 75.f

@implementation XFHomeTableNode

- (instancetype)initWithModel:(XFHomeDataModel *)model isBottom:(BOOL)isBottom {
    
    if (self = [super init]) {
        
        _model = model;
        _isBottomCell = isBottom;
        _picNode = [[XFNetworkImageNode alloc] init];
        _picNode.url = [NSURL URLWithString:_model.coverImageUrl];
        _picNode.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubnode:_picNode];
        
        _shadowNode = [[ASImageNode alloc] init];
        
        _shadowNode.image = [UIImage imageNamed:@"home_shadow"];
        
        [self addSubnode:_shadowNode];
        
        _tagNode = [[ASImageNode alloc] init];
        _tagNode.image = [UIImage imageNamed:@"home_tagbg"];
        [self addSubnode:_tagNode];
        
        _tagTextNode = [[ASTextNode alloc] init];
        [_tagTextNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor whiteColor] offset:0 text:_isBottomCell ? @"在线" : @"推荐" lineSpace:0 kern:2];
        [self addSubnode:_tagTextNode];
        
        _iconNode = [[XFNetworkImageNode alloc] init];
        _iconNode.url = [NSURL URLWithString:_model.headIconUrl];
        _iconNode.cornerRadius = 15;
        _iconNode.clipsToBounds = YES;
        
        [self addSubnode:_iconNode];
        
        _likeNode = [[ASButtonNode alloc] init];
        
        [_likeNode setImage:[UIImage imageNamed:@"home_like"] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        [_likeNode setTitle:[NSString stringWithFormat:@"%zd",[_model.likeNum integerValue]] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        [_likeNode addTarget:self action:@selector(clickLikeNode:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        _likeNode.selected = _model.likeIt ? YES : NO;
        
        [self addSubnode:_likeNode];
        

        // 小图标们
        NSArray *identifications = _model.identifications;
        
        NSMutableArray *icons = [NSMutableArray array];
        for (NSInteger i= 0 ; i < identifications.count ; i ++ ) {
            
            if ([[XFAuthManager sharedManager].ids containsObject:[NSString stringWithFormat:@"%@",identifications[i]]]) {
                
                NSInteger index = [[XFAuthManager sharedManager].ids indexOfObject:[NSString stringWithFormat:@"%@",identifications[i]]];
                
                XFNetworkImageNode *imgNode = [[XFNetworkImageNode alloc] init];
                imgNode.url = [NSURL URLWithString:[XFAuthManager sharedManager].icons[index]];
                [self addSubnode:imgNode];
                
                [icons addObject:imgNode];
            }
        }
        
        _authenticationIcons = icons.copy;
        
        // 名字
        _nameNode = [[ASTextNode alloc] init];
        _nameNode.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        [_nameNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:[UIColor whiteColor] offset:-1.5 text:_model.nickname lineSpace:0 kern:1];
        
        _nameNode.cornerRadius = 3;
        
        [self addSubnode:_nameNode];
        
        [_iconNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [_nameNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
    }
    
    return self;
}

#pragma mark - 点击按钮事件
// 点击头像--查看个人详情
- (void)clickIconNode {
    
    if ([self.delegate respondsToSelector:@selector(homeNode:didClickIconWithindex:)]) {
        [self.delegate homeNode:self didClickIconWithindex:self.indexPath];
    }
}

- (void)clickLikeNode:(ASButtonNode *)sender {
    
    if ([self.delegate respondsToSelector:@selector(homeNode:didClickLikeButtonWithIndex:)]) {
        
        [self.delegate homeNode:self didClickLikeButtonWithIndex:self.indexPath];
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    CGRect textFrame = [_nameNode.attributedText boundingRectWithSize:(CGSizeMake(MAXFLOAT, MAXFLOAT)) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil];

    CGFloat height;
    if (_isBottomCell) {
        
        height = kScreenWidth * 221/375.f;

    } else {
        height = kScreenWidth * 190/375.f;


    }
    _picNode.style.preferredSize = CGSizeMake(kScreenWidth, height);

    ASInsetLayoutSpec *insetText = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(8, 0, 0, 0)) child:_tagTextNode];
    ASOverlayLayoutSpec *overLayTag = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_tagNode overlay:insetText];
    overLayTag.style.preferredSize = CGSizeMake(40, 40);
    ASInsetLayoutSpec *tagInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 10, height - 40, kScreenWidth - 50)) child:overLayTag];
    
    ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_picNode overlay:tagInset];
    
    ASInsetLayoutSpec *shadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(height - 107 * kScreenWidth / 375.f, 0, 0, 0)) child:_shadowNode];
    
    ASOverlayLayoutSpec *overLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:shadowLayout];
    
    _iconNode.style.preferredSize = CGSizeMake(30, 30);
    
    // 底部几个小控件
    // 小图标
    
    for (ASImageNode *icon in self.authenticationIcons) {
        
        icon.style.preferredSize = CGSizeMake(12, 12);
        
    }
    ASStackLayoutSpec *iconsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:_authenticationIcons];
    
    // 小图标和名字
    
    _nameNode.style.preferredSize = CGSizeMake(textFrame.size.width + 15, 17);
    
    ASStackLayoutSpec *nameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:4 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,iconsLayout]];
    
    // 头像,小图标,名字
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsEnd) children:@[_iconNode,nameLayout]];
    
    iconNameLayout.style.spacingBefore = 10;
    
    // 点赞和价格
    
    _priceNode.style.preferredSize = CGSizeMake(58, 17);
    
    _likeNode.style.preferredSize = CGSizeMake(60, 20);
    
    ASStackLayoutSpec *rightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeNode]];
    
    ASStackLayoutSpec *allBottomLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsEnd) children:@[iconNameLayout,rightLayout]];
    
    ASInsetLayoutSpec *insetAll = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(kCellHeight - 60, 0, 22,10)) child:allBottomLayout];
    
    ASOverlayLayoutSpec *over1 = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overLayout overlay:insetAll];
    
    return over1;
    
}

@end
