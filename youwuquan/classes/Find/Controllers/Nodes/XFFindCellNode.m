//
//  XFFindCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindCellNode.h"
#import "XFIconmanager.h"

#define kTextShadowHeight 16
#define kTextShadowInset -16
#define kOpenMoreButtonPadding 15
#define kNoOpenMoreButtonPadding 0

@implementation XFFindCellNode

- (instancetype)initWithType:(FindCellType)type pics:(NSArray *)pics {
    
    if (self  = [super init]) {

        _pics = pics;
        _type = type;
        self.backgroundColor = UIColorHex(f4f4f4);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backNode = [[ASDisplayNode alloc] init];
        _backNode.backgroundColor = [UIColor whiteColor];
        _backNode.shadowColor = UIColorHex(e0e0e0).CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.4;
        _backNode.cornerRadius = 4;
        [self addSubnode:_backNode];
        
        // 图像
        NSMutableArray *nodes = [NSMutableArray array];
        for (NSInteger i = 0 ; i < _pics.count ; i ++ ) {
            
            ASNetworkImageNode *picNode = [[ASNetworkImageNode alloc] init];
            picNode.defaultImage = [UIImage imageNamed:_pics[i]];
            
            picNode.cornerRadius = 10;
            picNode.clipsToBounds = YES;
            
            [self addSubnode:picNode];
            [nodes addObject:picNode];
        }
        
        _picNodes = nodes.copy;
        
        // 图像遮罩
        _imgShadowNode = [[ASImageNode alloc] init];
//        _imgShadowNode.image = [UIImage imageNamed:@"overlay-zise"];
        [self addSubnode:_imgShadowNode];
        
        // 打赏
        _rewardButton = [[ASButtonNode alloc] init];
        
        [_rewardButton setImage:[UIImage imageNamed:@"find_dashang"] forState:(UIControlStateNormal)];
        //        _rewardButton.borderColor = [UIColor whiteColor].CGColor;
        //        _rewardButton.borderWidth = 2;
        [self addSubnode:_rewardButton];
        
        // 文字
        _contentNode = [[ASTextNode alloc] init];
        [_contentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:kRandomComment lineSpace:4 kern:1];
        _contentNode.maximumNumberOfLines = 3;
        [self addSubnode:_contentNode];
        
        // 更多按钮
        _moreButton = [[ASButtonNode alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"find_unfold"] forState:(UIControlStateNormal)];
        [_moreButton setImage:[UIImage imageNamed:@"find_retract"] forState:(UIControlStateSelected)];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [self addSubnode:_moreButton];
        // 横线
        _lineNode = [[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = UIColorHex(f5f5f5);
        [self addSubnode:_lineNode];
        
        // 时间
        _timeNode = [[ASTextNode alloc] init];
        [_timeNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"10 分钟前" lineSpace:2 kern:1];
        
        [self addSubnode:_timeNode];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        
        [self addSubnode:_likeButton];
        
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];
        
        [self addSubnode:_commentButton];
        
        // 图片遮罩
        _shadowNode = [[ASImageNode alloc] init];
        _shadowNode.image = [UIImage imageNamed:@"find_bai1"];
        
        [self addSubnode:_shadowNode];
        
        // 小图标们
        NSMutableArray *icons = [NSMutableArray array];
        for (NSInteger i= 0 ; i < 5 ; i ++ ) {
            
            ASImageNode *iconNode = [[ASImageNode alloc] init];
            
            iconNode.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c",65 + (int)i]];
            
            //            iconNode.backgroundColor = [UIColor redColor];
            
            [self addSubnode:iconNode];
            
            [icons addObject:iconNode];
            
            
        }
        
        _authenticationIcons = icons.copy;
        
        
        [_likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [_rewardButton addTarget:self action:@selector(clickRewardButton) forControlEvents:(ASControlNodeEventTouchUpInside)];

    }
    return self;
    
}

- (instancetype)initWithOpen:(BOOL)open pics:(NSArray *)pics {
    
    if (self  = [super init]) {
        _type = List;

        _isOpen = NO;
        
        _pics = pics;
        
        self.backgroundColor = UIColorHex(f4f4f4);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backNode = [[ASDisplayNode alloc] init];
        _backNode.backgroundColor = [UIColor whiteColor];
        _backNode.shadowColor = UIColorHex(e0e0e0).CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.4;
        _backNode.cornerRadius = 4;
        [self addSubnode:_backNode];
        
        _iconNode = [ASNetworkImageNode new];
        _iconNode.delegate = self;
        _iconNode.defaultImage = [UIImage imageNamed:kRandomIcon];
        
        _iconNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
          
            UIGraphicsBeginImageContext(image.size);
            
            UIBezierPath *path = [UIBezierPath
                                  bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height)
                                  cornerRadius:MIN(image.size.width,image.size.height)/2];
            
            [path addClip];
            
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            
            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return refinedImg;
            
        };
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:kRandomName];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        // 图标集合
        
        
        // 关注
        _approveButton = [[ASButtonNode alloc] init];
        [_approveButton setTitle:@"+ 关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_approveButton setTitle:@"已关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateSelected)];

        _approveButton.backgroundColor = UIColorHex(F72F5E);
        [self addSubnode:_approveButton];
        
        // 分享
        _shareButton = [[ASButtonNode alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
        [self addSubnode:_shareButton];
        
        // 图像
//        _picNode = [[ASNetworkImageNode alloc] init];
//        _picNode.defaultImage = [UIImage imageNamed:@"actor_pic2"];
//
//        [self addSubnode:_picNode];
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (NSInteger i = 0 ; i < _pics.count ; i ++ ) {
            
            ASNetworkImageNode *picNode = [[ASNetworkImageNode alloc] init];
            picNode.defaultImage = [UIImage imageNamed:_pics[i]];
            picNode.cornerRadius = 10;
            picNode.clipsToBounds = YES;
            [self addSubnode:picNode];
            [nodes addObject:picNode];
        }
        
        _picNodes = nodes.copy;
        
        
        // 图像遮罩
        _imgShadowNode = [[ASImageNode alloc] init];
//        _imgShadowNode.image = [UIImage imageNamed:@"overlay-zise"];
        [self addSubnode:_imgShadowNode];
        
        // 打赏
        _rewardButton = [[ASButtonNode alloc] init];

        [_rewardButton setImage:[UIImage imageNamed:@"find_dashang"] forState:(UIControlStateNormal)];
//        _rewardButton.borderColor = [UIColor whiteColor].CGColor;
//        _rewardButton.borderWidth = 2;
        [self addSubnode:_rewardButton];
        
        // 文字
        _contentNode = [[ASTextNode alloc] init];
        [_contentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:kRandomComment lineSpace:4 kern:1];
        _contentNode.maximumNumberOfLines =3;
        _contentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_contentNode];
        
        // 更多按钮
        _moreButton = [[ASButtonNode alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"find_unfold"] forState:(UIControlStateNormal)];
        [_moreButton setImage:[UIImage imageNamed:@"find_retract"] forState:(UIControlStateSelected)];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [self addSubnode:_moreButton];
        // 横线
        _lineNode = [[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = UIColorHex(f5f5f5);
        [self addSubnode:_lineNode];
        
        // 时间
        _timeNode = [[ASTextNode alloc] init];
        [_timeNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"10 分钟前" lineSpace:2 kern:0];
        
        [self addSubnode:_timeNode];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];

        [self addSubnode:_likeButton];
        
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];

        [self addSubnode:_commentButton];
        
        // 图片遮罩
        _shadowNode = [[ASImageNode alloc] init];
        _shadowNode.image = [UIImage imageNamed:@"find_bai1"];
        _shadowNode.cornerRadius = 10;
        _shadowNode.clipsToBounds = YES;
        [self addSubnode:_shadowNode];
        
        // 小图标们
        NSMutableArray *icons = [NSMutableArray array];
        for (NSInteger i= 0 ; i < 5 ; i ++ ) {
            
            ASImageNode *iconNode = [[ASImageNode alloc] init];
            
            iconNode.image = [UIImage imageNamed:[XFIconmanager sharedManager].authIcons[i]];

            //            iconNode.backgroundColor = [UIColor redColor];
            
            [self addSubnode:iconNode];
            
            [icons addObject:iconNode];
            
            
        }
        
        _authenticationIcons = icons.copy;
        
        [_likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_approveButton addTarget:self action:@selector(clickApproveButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_iconNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_nameNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_rewardButton addTarget:self action:@selector(clickRewardButton) forControlEvents:(ASControlNodeEventTouchUpInside)];

    }
    return self;
}

// 打赏
- (void)clickRewardButton {
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickRewardButtonWithIndex:)]) {
        
        [self.delegate findCellNode:self didClickRewardButtonWithIndex:self.indexPath];
        
    }
    
}

// 点击查看人物详情
- (void)clickIconNode {
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickIconForIndex:)]) {
        
        [self.delegate findCellNode:self didClickIconForIndex:self.indexPath];
    }
}

// 关注
- (void)clickApproveButton:(ASButtonNode *)sender {
    
    sender.selected = !sender.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
       
        if (sender.selected) {
            
            sender.backgroundColor = [UIColor lightGrayColor];

        } else {
            
            sender.backgroundColor = kMainRedColor;

        }
        
    }];

}

- (void)clickLikeButton {
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickLikeButtonForIndex:)]) {
        
        [self.delegate findCellNode:self didClickLikeButtonForIndex:self.indexPath];
    }
    
}

- (void)clickMoreButton:(ASButtonNode *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {

        self.isOpen = YES;
        self.shadowNode.hidden = YES;
    } else {

        self.shadowNode.hidden = NO;
        self.isOpen = NO;

    }
    
    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:YES measurementCompletion:^{
        
        [self setNeedsLayout];
        [self layoutIfNeeded];

    }];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    if (self.isOpen) {

        self.contentNode.maximumNumberOfLines = 0;

    } else {

        self.contentNode.maximumNumberOfLines = 2;

    }
    
    if (self.type == List) {
        
        _iconNode.style.preferredSize = CGSizeMake(45, 45);
        _iconNode.style.spacingBefore = 13;
        _iconNode.style.flexGrow = 0;
        _iconNode.style.flexGrow = 0;
        _iconNode.style.flexBasis = ASDimensionAuto;
        _iconNode.style.flexShrink = 0;
        
        _nameNode.style.spacingBefore = 5;
        _nameNode.style.flexShrink = YES;
        _nameNode.style.preferredSize = CGSizeMake(100, 20);
        
        _approveButton.style.spacingAfter = 8;
        _approveButton.style.preferredSize = CGSizeMake(70, 28);
        _approveButton.cornerRadius = 3;
        _shareButton.style.spacingAfter = 19;

        
        for (ASImageNode *img in _authenticationIcons) {
            
            img.style.preferredSize = CGSizeMake(12, 12);
            
        }
        // 名字和小图标
        ASStackLayoutSpec *iconsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_authenticationIcons];
        
        ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,iconsLayout]];
        
        // 名字和头像
        ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
        
        // 右边两个button
        ASStackLayoutSpec *shareLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_approveButton,_shareButton]];
        
        // 上面一层
        ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,shareLayout]];
        
        upLayout.style.spacingBefore = 17;
        upLayout.style.spacingAfter = 18;
        //图像比例   19/35
        CGFloat picWidth = kScreenWidth - 20;
        
        CGFloat picShadowHeight = picWidth * 19/35.f * 6/19.f;
        
        CGFloat littlePicWidth = (picWidth - 6)/3;
        CGFloat middlePicWidth = (picWidth - 3)/2;

        _imgShadowNode.style.preferredSize = CGSizeMake(picWidth, picShadowHeight);
        _rewardButton.style.preferredSize = CGSizeMake(65, 65);
        
        ASStackLayoutSpec *picButtonLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[]];

        if (_pics.count == 1) {

            ASNetworkImageNode *picNode = self.picNodes[0];
            CGSize imgSize = picNode.defaultImage.size;
            CGFloat leftInset = 0;
            CGFloat picHeight = 0;
            
            if (imgSize.height > imgSize.width) {
                
                picWidth = picWidth/2;
                picHeight = picWidth * imgSize.height/imgSize.width;
                leftInset = picWidth;
                
                if (picHeight > kScreenWidth) {
                    
                    picHeight = kScreenWidth;
                    
                }
                
            } else {
                
                picHeight = picWidth * imgSize.height/imgSize.width;
                
            }
            
            picNode.style.preferredSize = CGSizeMake(picWidth, picHeight);

            // 图像
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(picHeight - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picNode overlay:picShadowLayout];
            
            ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, -leftInset, 0, 0)) child:picLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picInset,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count == 4) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(middlePicWidth, middlePicWidth);

            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1]]];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[2],_picNodes[3]]];

//            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[upPicLayout,downPicLayout]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0,0)) child:picsLayout];
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 1 && _pics.count <= 3) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  -littlePicWidth * (3 - _picNodes.count), 0,0)) child:upPicLayout];

            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 3 && _pics.count <= 6) {
            
            NSMutableArray *downNodes = [NSMutableArray array];
            for (NSInteger i = 0 ; i <_picNodes.count ; i ++ ) {
                
                ASNetworkImageNode *picNode = _picNodes[i];
                
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
                if (i > 2) {
                    
                    [downNodes addObject:picNode];
                    
                }
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1],_picNodes[2]]];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:downNodes];
            
            //            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[upPicLayout,downPicLayout]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 6 && _pics.count <= 9) {
            
            NSMutableArray *centerNodes = [NSMutableArray array];
            NSMutableArray *downNodes = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i <_picNodes.count ; i ++ ) {
                
                ASNetworkImageNode *picNode = _picNodes[i];
                
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
                if (i > 2 && i < 6) {
                    
                    [centerNodes addObject:picNode];
                    
                }
                
                if (i >= 6 && i < 9) {
                    
                    [downNodes addObject:picNode];

                }
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1],_picNodes[2]]];
            ASStackLayoutSpec *centerPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:centerNodes];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:downNodes];

            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,centerPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 3 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
        }
        

        
        
        CGFloat textWidth = kScreenWidth - 20 - 36;
        
        // 文字
        _contentNode.style.flexShrink = 1;
        _shadowNode.style.preferredSize = CGSizeMake(textWidth, kTextShadowHeight);
        _shadowNode.style.spacingBefore = kTextShadowInset;
        _contentNode.style.width = ASDimensionMake(textWidth);
        
        _shadowNode.style.spacingAfter = 0;
        _shadowNode.style.flexGrow = 1;
        if (_isOpen) {
            
            _moreButton.style.spacingBefore = kOpenMoreButtonPadding;

        } else {
            _moreButton.style.spacingBefore = kNoOpenMoreButtonPadding;

            
        }
        _moreButton.style.preferredSize = CGSizeMake(60, 40);
        // 渐变
        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_contentNode,_shadowNode,_moreButton]];
        
        ASInsetLayoutSpec *contentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 18, 0, 18)) child:contentShadow];
        
        // 底部控件
        _lineNode.style.height = ASDimensionMake(1);
        _lineNode.style.spacingBefore = 0;
        
        _timeNode.style.spacingBefore = 17;
        _likeButton.style.spacingAfter = 23;
        _commentButton.style.spacingAfter = 25;
        
        ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeButton,_commentButton]];
        
        ASStackLayoutSpec *downLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[_timeNode,likeLayout]];
        
        downLayout.style.spacingBefore = 19;
        
        downLayout.style.spacingAfter = 19;
        
        // 全部布局
        ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upLayout,picButtonLayout,contentInset,_lineNode,downLayout]];
        
        
        ASBackgroundLayoutSpec *backLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:centerLayout background:_backNode];
        
        _backNode.shadowColor = [UIColor blackColor].CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.1;
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 5, 10)) child:backLayout];
        
    } else {
        
        
        // 个人资料中
        
        
        //图像比例   19/35
        CGFloat picWidth = kScreenWidth - 20;
        CGFloat picHeight = picWidth * 19/35.f;
        
        CGFloat picShadowHeight = picHeight * 6/19.f;
        CGFloat littlePicWidth = (picWidth - 6)/3;
        CGFloat middlePicWidth = (picWidth - 3)/2;

        _imgShadowNode.style.preferredSize = CGSizeMake(picWidth, picShadowHeight);
        _rewardButton.style.preferredSize = CGSizeMake(65, 65);
        
        ASStackLayoutSpec *picButtonLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[]];
        
        if (_pics.count == 1) {
            
            ASNetworkImageNode *picNode = self.picNodes[0];
            CGSize imgSize = picNode.defaultImage.size;
            CGFloat leftInset = 0;
            CGFloat picHeight = 0;
            
            if (imgSize.height > imgSize.width) {
                
                picWidth = picWidth/2;
                picHeight = picWidth * imgSize.height/imgSize.width;
                leftInset = picWidth;
                
                if (picHeight > kScreenWidth) {
                    
                    picHeight = kScreenWidth;
                    
                }
                
            } else {
                
                picHeight = picWidth * imgSize.height/imgSize.width;
                
            }
            
            picNode.style.preferredSize = CGSizeMake(picWidth, picHeight);
            
            // 图像
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(picHeight - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picNode overlay:picShadowLayout];
            
            ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, -leftInset, 0, 0)) child:picLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picInset,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count == 4) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(middlePicWidth, middlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1]]];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[2],_picNodes[3]]];
            
            //            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[upPicLayout,downPicLayout]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  0, 0,0)) child:picsLayout];
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 1 && _pics.count <= 3) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  -littlePicWidth * (3 - _picNodes.count), 0,0)) child:upPicLayout];
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 3 && _pics.count <= 6) {
            
            NSMutableArray *downNodes = [NSMutableArray array];
            for (NSInteger i = 0 ; i <_picNodes.count ; i ++ ) {
                
                ASNetworkImageNode *picNode = _picNodes[i];
                
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
                if (i > 2) {
                    
                    [downNodes addObject:picNode];
                    
                }
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1],_picNodes[2]]];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:downNodes];
            
            //            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[upPicLayout,downPicLayout]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_pics.count > 6 && _pics.count <= 9) {
            
            NSMutableArray *centerNodes = [NSMutableArray array];
            NSMutableArray *downNodes = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i <_picNodes.count ; i ++ ) {
                
                ASNetworkImageNode *picNode = _picNodes[i];
                
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
                if (i > 2 && i < 6) {
                    
                    [centerNodes addObject:picNode];
                    
                }
                
                if (i >= 6 && i < 9) {
                    
                    [downNodes addObject:picNode];
                    
                }
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1],_picNodes[2]]];
            ASStackLayoutSpec *centerPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:centerNodes];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:downNodes];
            
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,centerPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 3 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
        }
        

        
        // 文字
        // 文字
        _contentNode.style.flexShrink = 1;
        _shadowNode.style.preferredSize = CGSizeMake(picWidth-36, kTextShadowHeight);
        _shadowNode.style.spacingBefore = kTextShadowInset;
        _contentNode.style.width = ASDimensionMake(picWidth-36);
        
        _shadowNode.style.spacingAfter = 0;
        _shadowNode.style.flexGrow = 1;
        if (_isOpen) {
            
            _moreButton.style.spacingBefore = kOpenMoreButtonPadding;
            
        } else {
            _moreButton.style.spacingBefore = kNoOpenMoreButtonPadding;
            
            
        }
        _moreButton.style.preferredSize = CGSizeMake(60, 40);
        // 渐变
        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_contentNode,_shadowNode,_moreButton]];
        
        ASInsetLayoutSpec *contentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 18, 0, 18)) child:contentShadow];
        
        // 底部控件
        _lineNode.style.height = ASDimensionMake(1);
        _lineNode.style.spacingBefore = 0;
        
        _timeNode.style.spacingBefore = 17;
        _likeButton.style.spacingAfter = 23;
        _commentButton.style.spacingAfter = 25;
        
        ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeButton,_commentButton]];
        
        ASStackLayoutSpec *downLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[_timeNode,likeLayout]];
        
        downLayout.style.spacingBefore = 19;
        
        downLayout.style.spacingAfter = 19;
        
        // 全部布局
        ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[picButtonLayout,contentInset,_lineNode,downLayout]];
        
        
        ASBackgroundLayoutSpec *backLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:centerLayout background:_backNode];
        
        _backNode.shadowColor = [UIColor blackColor].CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.1;
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 5, 10)) child:backLayout];
        
        
    }
    

//    return upLayout;
}

@end
