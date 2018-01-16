//
//  XFFinddetailInfoTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFinddetailInfoTableViewCell.h"

@implementation XFFinddetailInfoTableViewCell

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {

    if (self = [super init]) {
        
        _userInfo = userInfo;
        
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
        [_heiNUmberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[NSString stringWithFormat:@"%@cm",_userInfo[@"height"]?_userInfo[@"height"]:@"0"] lineSpace:2 kern:0];
        _wightNumberNode = [[ASTextNode alloc] init];
        [_wightNumberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[NSString stringWithFormat:@"%@KG",_userInfo[@"weight"]?_userInfo[@"weight"]:@"0"] lineSpace:2 kern:0];
        _swNumberNode = [[ASTextNode alloc] init];
        
        NSString *bust = _userInfo[@"bust"]?_userInfo[@"bust"]:@"0";
        NSString *waist = _userInfo[@"waist"]?_userInfo[@"waist"]:@"0";
        NSString *hip = _userInfo[@"hip"]?_userInfo[@"hip"]:@"0";

        
        [_swNumberNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[NSString stringWithFormat:@"%@/%@/%@",bust,waist,hip] lineSpace:2 kern:0];
        
        // 简介
        _desNode = [[ASTextNode alloc] init];
        [_desNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"简介" lineSpace:2 kern:0];
        _desDetailNode = [[ASTextNode alloc] init];
        [_desDetailNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:UIColorHex(808080) offset:0 text:_userInfo[@"introduce"]?_userInfo[@"introduce"]:@"这个人很懒" lineSpace:4 kern:2];
        [self addSubnode:_bgNode];
        [self addSubnode:_heightNode];
        [self addSubnode:_wightNode];
        [self addSubnode:_swNode];
        [self addSubnode:_heiNUmberNode];
        [self addSubnode:_wightNumberNode];
        [self addSubnode:_swNumberNode];
        [self addSubnode:_desDetailNode];
        [self addSubnode:_desNode];
        
        _line1 = [[ASDisplayNode alloc] init];
        _line1.backgroundColor = UIColorHex(e0e0e0);
        [self addSubnode:_line1];
        _line2 = [[ASDisplayNode alloc] init];
        _line2.backgroundColor = UIColorHex(e0e0e0);
        [self addSubnode:_line2];
        _line3 = [[ASDisplayNode alloc] init];
        _line3.backgroundColor = UIColorHex(e0e0e0);
        [self addSubnode:_line3];
//        _line4 = [[ASDisplayNode alloc] init];
//        _line4.backgroundColor = UIColorHex(808080);
//        [self addSubnode:_line4];

    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _desNode.style.spacingBefore = 20;
    _desDetailNode.style.spacingBefore = 10;
    
    ASStackLayoutSpec *heightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_heightNode,_heiNUmberNode]];
    
    ASInsetLayoutSpec *heightInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(15, 0, 15, 0)) child:heightLayout];
    
    ASStackLayoutSpec *wightLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_wightNode,_wightNumberNode]];
    ASInsetLayoutSpec *weightInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(15, 0, 15, 0)) child:wightLayout];

    ASStackLayoutSpec *swLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_swNode,_swNumberNode]];
    ASInsetLayoutSpec *swInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(15, 0, 15, 0)) child:swLayout];

    _line1.style.preferredSize = CGSizeMake(1, 50);
    _line2.style.preferredSize = CGSizeMake(1, 50);
    _line3.style.preferredSize = CGSizeMake(kScreenWidth, 1);
    
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceAround) alignItems:(ASStackLayoutAlignItemsCenter) children:@[heightInset,_line1,weightInset,_line2,swInset]];
    
    CGRect desFrame = [_desNode frameForTextRange:NSMakeRange(0, _desNode.attributedText.length)];
    
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 15, 10, kScreenWidth - desFrame.size.width - 15)) child:_desNode];
    inset.style.spacingBefore = 20;
    
    ASInsetLayoutSpec *detailinse = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 15, 0, 15)) child:_desDetailNode];
    // 简介
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upLayout,_line3,inset,detailinse]];
    
    ASInsetLayoutSpec *allInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:allLayout];
    
    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:allInset background:_bgNode];
    
    ASInsetLayoutSpec *bgInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];


    return bgInset;
    
}

@end
