//
//  XFHomeTableNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeTableNode.h"

#import "XFIconmanager.h"

#define kCellHeight kScreenWidth * 38 / 75.f

@implementation XFHomeTableNode

- (instancetype)initWithModel:(XFHomeDataModel *)model {
    
    if (self = [super init]) {
        
        _model = model;
        
        _picNode = [[XFNetworkImageNode alloc] init];
        _picNode.url = [NSURL URLWithString:_model.coverImage[@"thumbImage500pxUrl"]];
        _picNode.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubnode:_picNode];
        
        _shadowNode = [[ASImageNode alloc] init];
        
        _shadowNode.image = [UIImage imageNamed:@"overlay-zise"];
        
        [self addSubnode:_shadowNode];
        
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
        
        _likeNode.selected = [_model.isLiked intValue] == 0 ? NO : YES;
        
        [self addSubnode:_likeNode];
        
        _priceNode = [[ASTextNode alloc] init];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        
        NSMutableAttributedString *priceStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元起",_model.price]];
        
        priceStr.attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11],
                                
                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSBaselineOffsetAttributeName: @(-2),// 基线偏移,保持垂直居中

                                };
        
        _priceNode.attributedText = priceStr;
        
        _priceNode.backgroundColor = UIColorHex(0x5f7ff6);
        
        _priceNode.cornerRadius = 5;
        _priceNode.clipsToBounds = YES;
        
        
        [self addSubnode:_priceNode];

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
        NSMutableParagraphStyle *nameStyle = [[NSMutableParagraphStyle alloc] init];
        
        nameStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *nameStr =[[NSMutableAttributedString alloc] initWithString:_model.nickname];
        
        nameStr.attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11],
                                
                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSBaselineOffsetAttributeName: @(-1.5),
                                };
        
        _nameNode.attributedText = nameStr;
        
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

    
    _picNode.style.preferredSize = CGSizeMake(kScreenWidth, kScreenWidth * 42/75.f);

    ASStackLayoutSpec *picLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_picNode]];
    
    ASInsetLayoutSpec *shadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(kCellHeight - 32, 0, 0, 0)) child:_shadowNode];
    
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
    
    ASStackLayoutSpec *rightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeNode,_priceNode]];
    
    ASStackLayoutSpec *allBottomLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsEnd) children:@[iconNameLayout,rightLayout]];
    
    ASInsetLayoutSpec *insetAll = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(kCellHeight - 60, 0, 8,10)) child:allBottomLayout];
    
    ASOverlayLayoutSpec *over1 = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:overLayout overlay:insetAll];
    
    return over1;
    
    
}

@end
