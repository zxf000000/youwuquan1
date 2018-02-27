//
//  XFMyHeaderNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyHeaderNode.h"
#import "XFAuthManager.h"

@implementation XFMyHeadercellnode

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _iconNode = [[ASImageNode alloc] init];
        _iconNode.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubnode:_iconNode];
        
        _titleNode = [[ASTextNode alloc] init];
        [self addSubnode:_titleNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _iconNode.style.preferredSize = CGSizeMake(35, 35);
    
    ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:16 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,_titleNode]];
    
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:(ASCenterLayoutSpecCenteringXY) sizingOptions:(ASCenterLayoutSpecSizingOptionDefault) child:stackLayout];
    
}

@end

@implementation XFMyHeaderNode

- (instancetype)initWithUserinfo:(NSDictionary *)userInfo {
    
    if (self = [super init]) {
        
        _userInfo = userInfo;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = kBgGrayColor;
        
        _BgNode = [[ASDisplayNode alloc] init];
        _BgNode.shadowColor = UIColorHex(808080).CGColor;
        _BgNode.shadowOffset = CGSizeMake(0, 0);
        _BgNode.shadowOpacity = 0.5;
        _BgNode.backgroundColor = [UIColor whiteColor];
        
        _topBgNode = [[ASDisplayNode alloc] init];
        _topBgNode.backgroundColor = [UIColor whiteColor];

        _topBgNode.shadowColor = UIColorHex(808080).CGColor;
        _topBgNode.shadowOffset = CGSizeMake(0, 0);
        _topBgNode.shadowOpacity = 0.5;
        _fansLabel = [[ASTextNode alloc] init];
        
        // 三个数字
        NSString *likeNum = _userInfo[@"info"][@"followNum"];
        NSString *fansNum = _userInfo[@"info"][@"fansNum"];
        NSString *statusNum = _userInfo[@"info"][@"publishNum"];
        
        
        [_fansLabel setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"粉丝" lineSpace:2 kern:0];
        
        _fansNumberLabel = [[ASTextNode alloc] init];
        [_fansNumberLabel setFont:[UIFont systemFontOfSize:15] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:fansNum?[NSString stringWithFormat:@"%@",fansNum]:@"0" lineSpace:2 kern:0];
    
        _careLabel = [[ASTextNode alloc] init];
        [_careLabel setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"关注" lineSpace:2 kern:0];
        
        _careNumberLabel = [[ASTextNode alloc] init];
        [_careNumberLabel setFont:[UIFont systemFontOfSize:15] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:likeNum?[NSString stringWithFormat:@"%@",likeNum]:@"0" lineSpace:2 kern:0];
    
        _statusLabel = [[ASTextNode alloc] init];
        [_statusLabel setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"动态" lineSpace:2 kern:0];
        
        _statusNumberLabel = [[ASTextNode alloc] init];
        [_statusNumberLabel setFont:[UIFont systemFontOfSize:15] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:statusNum?[NSString stringWithFormat:@"%@",statusNum]:@"0" lineSpace:2 kern:0];
        
        _fansButton = [[ASButtonNode alloc] init];
        _caresButton = [[ASButtonNode alloc] init];
        _statusNode = [[ASButtonNode alloc] init];
        
        [_fansButton addTarget:self action:@selector(clickFansNode) forControlEvents:(ASControlNodeEventTouchUpInside)];

        [_caresButton addTarget:self action:@selector(clickCaresNode) forControlEvents:(ASControlNodeEventTouchUpInside)];

        [_statusNode addTarget:self action:@selector(clickStatusLabel) forControlEvents:(ASControlNodeEventTouchUpInside)];

        
        [self addSubnode:_BgNode];
        [self addSubnode:_topBgNode];
        [self addSubnode:_fansNumberLabel];
        [self addSubnode:_fansLabel];
        [self addSubnode:_careLabel];
        [self addSubnode:_careNumberLabel];
        [self addSubnode:_statusLabel];
        [self addSubnode:_statusNumberLabel];
        [self addSubnode:_fansButton];
        [self addSubnode:_caresButton];
        [self addSubnode:_statusNode];

        // button
        _inviteButton = [[ASButtonNode alloc] init];
        [_inviteButton setTitle:@"邀请有礼" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_inviteButton setImage:[UIImage imageNamed:@"me_yaoqing"] forState:(UIControlStateNormal)];
        _inviteButton.backgroundColor = kBlueColor;
        [_inviteButton addTarget:self action:@selector(clickInviteButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [self addSubnode:_inviteButton];
        
        // collection
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat itemWidth = (kScreenWidth - 4)/3;
        
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.backgroundColor = kBgGrayColor;
        [self addSubnode:_collectionNode];
        
        _collectionNode.shadowColor = UIColorHex(808080).CGColor;
        _collectionNode.shadowOffset = CGSizeMake(0, 0);
        _collectionNode.shadowOpacity = 0.5;
        
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
       
        XFMyAuthModel *model = [[XFAuthManager sharedManager].authList lastObject];
        
        
//        if ([model.identificationName isEqualToString:@"基本认证"]) {
//            _isUp = YES;
//            _imgs = @[@"me_zl",@"me_rz",@"me_fh",@"me_jn"];
//            _titles = @[@"我的资料",@"我的认证",@"VIP富豪榜",@"我的技能"];
//
//        } else {
            _isUp = NO;
            _imgs = @[@"me_zl",@"me_rz",@"mine_vip",@"me_cf",@"me_fh",@"me_jn"];
            _titles = @[@"我的资料",@"我的认证",@"VIP中心",@"我的财富",@"VIP富豪榜",@"我的技能"];
//        }
        



    }
    return self;
}


- (void)clickFansNode {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickfanslabel)]) {
        
        [self.delegate headerDidClickfanslabel];
    }
    
}

- (void)clickCaresNode {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickCarelabel)]) {
        
        [self.delegate headerDidClickCarelabel];
    }
}

- (void)clickStatusLabel {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickStatuslabel)]) {
        
        [self.delegate headerDidClickStatuslabel];
    }
    
}


#pragma mark - 邀请有礼
- (void)clickInviteButton {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickInvitebutton)]) {
        
        [self.delegate headerDidClickInvitebutton];
    }
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return self.titles.count;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode*() {
      
        XFMyHeadercellnode *node = [[XFMyHeadercellnode alloc] init];
        
        node.iconNode.image = [UIImage imageNamed:self.imgs[indexPath.row]];
        [node.titleNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:self.titles[indexPath.row] lineSpace:2 kern:0];
        
        return node;
    };
    
}
#pragma mark - collectionNodeDelegate
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(headerDidSelectItemAtIndex:)]) {
        
        [self.delegate headerDidSelectItemAtIndex:indexPath.item];
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *fansLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:6 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_fansNumberLabel,_fansLabel]];
    
    
    ASStackLayoutSpec *careLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:6 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_careNumberLabel,_careLabel]];
    
    ASStackLayoutSpec *statusLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:6 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_statusNumberLabel,_statusLabel]];
    
    fansLayout.style.preferredSize = CGSizeMake(100, 71);
    careLayout.style.preferredSize = CGSizeMake(100, 71);
    statusLayout.style.preferredSize = CGSizeMake(100, 71);

    ASOverlayLayoutSpec *fansOver = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:fansLayout overlay:_fansButton];
    ASOverlayLayoutSpec *caresOver = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:careLayout overlay:_caresButton];
    ASOverlayLayoutSpec *statusOver = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:statusLayout overlay:_statusNode];

    
    ASStackLayoutSpec *topLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceAround) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStart) children:@[fansOver,caresOver,statusOver]];
    
    ASInsetLayoutSpec *topInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(40, 0, 0, 0)) child:topLayout];
    
    _inviteButton.style.preferredSize = CGSizeMake(kScreenWidth, 50);
    
    ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStretch) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[topInset,_inviteButton]];

    ASBackgroundLayoutSpec *upBglayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:centerLayout background:_topBgNode];
    
    ASInsetLayoutSpec *centerInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:upBglayout];
    
    // 底部Collection
    CGFloat collectionHeight = (kScreenWidth - 2)/3*2 + 2;
    
    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, collectionHeight);
    
    
    ASBackgroundLayoutSpec *downBg = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_collectionNode background:_BgNode];
    ASInsetLayoutSpec *collectionbgInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:downBg];

    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStretch) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[centerInset,collectionbgInset]];

    return allLayout;
    
}



@end
