//
//  XFFindCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyStatusCellNode.h"
#import "XFIconmanager.h"

#define kTextShadowHeight 16
#define kTextShadowInset -16
#define kOpenMoreButtonPadding 15
#define kNoOpenMoreButtonPadding 0
#define kPicSpace 42.f * kScreenWidth / 375.f


@implementation XFMyStatusCellNode

- (instancetype)initWithPics:(NSArray *)pics open:(BOOL)open model:(XFStatusModel *)model{
    
    if (self  = [super init]) {
        
        _isOpen = open;
        _pics = pics;
        _model = model;
        self.backgroundColor = UIColorHex(f4f4f4);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backNode = [[ASDisplayNode alloc] init];
        _backNode.backgroundColor = [UIColor whiteColor];
        _backNode.shadowColor = UIColorHex(e0e0e0).CGColor;
        _backNode.shadowOffset = CGSizeMake(0, 0);
        _backNode.shadowOpacity = 0.4;
        _backNode.cornerRadius = 4;
        [self addSubnode:_backNode];
        
        _iconNode = [[XFNetworkImageNode alloc] init];;
        _iconNode.image = [UIImage imageNamed:@"31"];
        _iconNode.url = [NSURL URLWithString:[XFUserInfoManager sharedManager].userInfo[@"basicInfo"][@"headIconUrl"]];
        _iconNode.cornerRadius = 22.5;
        _iconNode.clipsToBounds = YES;
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:[XFUserInfoManager sharedManager].userInfo[@"basicInfo"][@"nickname"]];
        
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
        _approveButton.hidden = YES;
        
        // 分享
        _shareButton = [[ASButtonNode alloc] init];
        [_shareButton setTitle:@"分享" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_shareButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
        [self addSubnode:_shareButton];
        
        // 图
        
        NSMutableArray *allImgs = [NSMutableArray array];
        
        NSArray *opens = _model.pictures;

        
        [allImgs addObjectsFromArray:opens];
        _allImgs = allImgs.copy;
        _picCount = allImgs.count;
        
        NSMutableArray *nodes = [NSMutableArray array];
        
        if (_model.video) {
            
            ASNetworkImageNode *picNode = [[ASNetworkImageNode alloc] init];
            
            picNode.defaultImage = [UIImage imageNamed:@"zhanweitu33"];
            picNode.URL = [NSURL URLWithString:_model.video[@"video"][@"coverUrl"]];
            
            picNode.cornerRadius = 10;
            picNode.clipsToBounds = YES;
            [self addSubnode:picNode];
            [nodes addObject:picNode];
            
            _picCount = 1;
            
        } else {
            
            for (NSInteger i = 0 ; i < _allImgs.count ; i ++ ) {
                
                NSDictionary *imgDic = _allImgs[i];
                
                XFNetworkImageNode *picNode = [[XFNetworkImageNode alloc] init];
                
                picNode.image = [UIImage imageNamed:@"zhanweitu33"];
                picNode.url = [NSURL URLWithString:imgDic[@"image"][@"thumbImage500pxUrl"]];
                picNode.cornerRadius = 10;
                picNode.clipsToBounds = YES;
                [self addSubnode:picNode];
                [nodes addObject:picNode];
            }
        }
        

        
        _picNodes = nodes.copy;
        
        _playButton = [[ASButtonNode alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"video_play"] forState:(UIControlStateNormal)];
        _playButton.contentMode = UIViewContentModeScaleToFill;
        [self addSubnode:_playButton];
        
        if (_model.video) {

            _playButton.hidden = NO;

        } else {

            _playButton.hidden = YES;


        }
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
        _rewardButton.hidden = YES;
        
        // 标签
        NSArray *tags = _model.labels;
        NSMutableArray *tagNodes = [NSMutableArray array];
        for (int i = 0; i < tags.count; i ++ ) {
            NSString *tag = tags[i];
            ASTextNode *node = [[ASTextNode alloc] init];
            [node setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:[NSString stringWithFormat:@"# %@",tag] lineSpace:0 kern:2];
            [self addSubnode:node];
            [tagNodes addObject:node];
        }
        self.tagNodes = tagNodes.copy;
        
        // 文字
        _contentNode = [[ASTextNode alloc] init];
        [_contentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.title lineSpace:4 kern:1];
        _contentNode.maximumNumberOfLines = 2;
        _contentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_contentNode];
        
        _allcontentNode = [[ASTextNode alloc] init];
        [_allcontentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.title lineSpace:4 kern:1];
        _allcontentNode.maximumNumberOfLines = 0;
        _allcontentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_allcontentNode];
        
        
        // 小于三行隐藏遮罩和更多按钮
        // 获取文字属性
        CGRect contentFrame = [_allcontentNode frameForTextRange:(NSMakeRange(0, _allcontentNode.attributedText.length))];
        CGFloat width = contentFrame.size.width;
        
        // 更多按钮
        _moreButton = [[ASButtonNode alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"find_unfold"] forState:(UIControlStateNormal)];
        [_moreButton setImage:[UIImage imageNamed:@"find_retract"] forState:(UIControlStateSelected)];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        
        // 图片遮罩
        _shadowNode = [[ASImageNode alloc] init];
        _shadowNode.image = [UIImage imageNamed:@"find_bai1"];
        _shadowNode.cornerRadius = 10;
        _shadowNode.clipsToBounds = YES;
        [self addSubnode:_shadowNode];
        [self addSubnode:_moreButton];
#pragma mark - 判断多少行
        if (width / (kScreenWidth - 2 * kPicSpace) <= 2) {
            
            _moreButton.hidden = YES;
            _shadowNode.hidden = YES;
            
        } else {
            
            
            _moreButton.hidden = NO;
            _shadowNode.hidden = NO;
            
        }
        // 横线
        _lineNode = [[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = UIColorHex(f5f5f5);
        [self addSubnode:_lineNode];
        
        // 时间
        _timeNode = [[ASTextNode alloc] init];
        [_timeNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[XFToolManager changeLongToDateWith:_model.createTime] lineSpace:2 kern:0];
        
        [self addSubnode:_timeNode];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:[NSString stringWithFormat:@"%@",_model.likeNum] withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];

        [self addSubnode:_likeButton];
        
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:[NSString stringWithFormat:@"%@",_model.commentNum] withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];

        [self addSubnode:_commentButton];
        
        _moneyButton = [[ASButtonNode alloc] init];
        [_moneyButton setTitle:[NSString stringWithFormat:@"收入 %@",[NSString stringWithFormat:@"%zd",[_model.receivedDiamonds intValue]]] withFont:[UIFont systemFontOfSize:11] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_moneyButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
        
        [self addSubnode:_moneyButton];
        
        _setbutton = [[ASButtonNode alloc] init];
        [_setbutton setImage:[UIImage imageNamed:@"find_set"] forState:(UIControlStateNormal)];
        
        [self addSubnode:_setbutton];
        
        // 图片遮罩
        _shadowNode = [[ASImageNode alloc] init];
        _shadowNode.image = [UIImage imageNamed:@"find_bai1"];
        _shadowNode.cornerRadius = 10;
        _shadowNode.clipsToBounds = YES;
        [self addSubnode:_shadowNode];
        
        // 小图标们
        NSArray *identifications = _model.user[@"identifications"];
        
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
        
        [_likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_approveButton addTarget:self action:@selector(clickApproveButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_iconNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_nameNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_rewardButton addTarget:self action:@selector(clickRewardButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        // 状态
        if (_isOpen) {
            
            _moreButton.selected = YES;
            _imgShadowNode.hidden = YES;
            
            
        } else {
            
            _moreButton.selected = NO;
            _imgShadowNode.hidden = NO;
            
        }

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

//    // 展开
//    [self.delegate findCellclickMpreButtonWithIndex:self.indexPath open:sender.selected];

    self.defaultLayoutTransitionDuration = 0.05;
    
    if (sender.selected) {
        
        self.isOpen = YES;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.shadowNode.alpha = 0;
            
        }];
        self.proContentNode = self.allcontentNode;
    } else {
        
        //        self.shadowNode.hidden = NO;
        self.isOpen = NO;
        self.proContentNode = self.contentNode;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.shadowNode.alpha = 1;
            
        }];
    }

//    self.automaticallyManagesSubnodes = YES;
    
    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:YES measurementCompletion:^{

        [self setNeedsLayout];

    }];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    if (self.isOpen) {
        
        self.proContentNode = self.allcontentNode;
        
    } else {
        
        self.proContentNode = self.contentNode;
    }
    
    _iconNode.style.preferredSize = CGSizeMake(45, 45);
    _iconNode.style.spacingBefore = 17;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexBasis = ASDimensionAuto;
    _iconNode.style.flexShrink = 0;
    
    _nameNode.style.spacingBefore = 5;
    _nameNode.style.flexShrink = YES;
    
    _approveButton.style.spacingAfter = 18;
    _approveButton.style.preferredSize = CGSizeMake(70, 28);
    _shareButton.style.spacingAfter = 0;
    _shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 30);
    
    _timeNode.style.spacingBefore = 6;
    
    for (ASImageNode *img in _authenticationIcons) {
        
        img.style.preferredSize = CGSizeMake(12, 12);
        
    }
    
    // 名字和时间
    ASStackLayoutSpec *nameTime = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_nameNode,_timeNode]];
    
    // 名字和小图标
    ASStackLayoutSpec *iconsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_authenticationIcons];
    
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[nameTime,iconsLayout]];
    
    
    //    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:4 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[nameTime,iconsLayout]];
    
    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
    
    // 右边两个button
    //        ASStackLayoutSpec *shareLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_approveButton,_shareButton]];
    
    // 上面一层
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentSpaceAround) children:@[iconNameLayout,_approveButton]];
    
    upLayout.style.spacingBefore = 17;
    upLayout.style.spacingAfter = 30;
    //图像比例   19/35
    CGFloat picWidth = kScreenWidth - kPicSpace * 2;
    
    CGFloat picShadowHeight = picWidth * 19/35.f * 6/19.f;
    
    CGFloat littlePicWidth = (picWidth - 6)/3;
    //        CGFloat middlePicWidth = (picWidth - 3)/2;
    
    _imgShadowNode.style.preferredSize = CGSizeMake(picWidth, picShadowHeight);
    //        _rewardButton.style.preferredSize = CGSizeMake(65, 65);
    
    ASStackLayoutSpec *picButtonLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[]];
    
    
    
    if (_picNodes.count == 1) {
        
        XFNetworkImageNode *picNode = self.picNodes[0];
        
        CGSize imgSize;
        if (_model.video) {
            
            imgSize = CGSizeMake(picWidth, picWidth * 19/35.f);
            
        } else {
            
            NSDictionary *picInfo = _model.pictures[0];
            imgSize = CGSizeMake([picInfo[@"image"][@"width"] floatValue], [picInfo[@"image"][@"height"] floatValue]);
            
        }
        CGFloat picHeight = 0;
        
        if (imgSize.height > imgSize.width) {
            
            picWidth = picWidth/2;
            picHeight = picWidth * imgSize.height/imgSize.width;
            
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
        
        _playButton.style.preferredSize = CGSizeMake(80, 80);
        
        ASInsetLayoutSpec *insetPlay = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake((picHeight - 80)/2, (picWidth - 80)/2, (picHeight - 80)/2, (picWidth - 80)/2)) child:_playButton];
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:insetPlay];
        
        ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, (kScreenWidth - kPicSpace - picWidth))) child:picPlayLayout];
        
        picButtonLayout = picInset;
        
    } else if (_picNodes.count == 4) {
        
        for (XFNetworkImageNode *picNode in _picNodes) {
            picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
            
        }
        

        
        ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1]]];
        ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[2],_picNodes[3]]];
        
        ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
        
        
        ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, (kScreenWidth - littlePicWidth * 3)/2, 0,(kScreenWidth - littlePicWidth * 3)/2 + littlePicWidth + 3)) child:picsLayout];
        
        ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
        
        
        ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
        
        
        picButtonLayout = picPlayLayout;
        
    } else if (_picNodes.count == 2) {
        
        for (int i = 0 ; i < _picNodes.count ; i++) {
            
            XFNetworkImageNode *node = _picNodes[i];
            node.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
            
        }
        

        
        ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
        
        ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, (kScreenWidth - littlePicWidth * 3)/2, 0,(kScreenWidth - littlePicWidth * 3)/2 + littlePicWidth + 3)) child:upPicLayout];
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:_playButton];
        
        picButtonLayout = picPlayLayout;
        
    } else if (_picNodes.count > 1 && _picNodes.count <= 3) {
        
        for (ASNetworkImageNode *picNode in _picNodes) {
            
            picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
            
        }
        

        
        ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
        
        ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  -littlePicWidth * (3 - _picNodes.count), 0,0)) child:upPicLayout];
        
        ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
        
        ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
        
        ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:picPlayLayout];
        
        //            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
        
        picButtonLayout = picInset;
        
    } else if (_picNodes.count > 3 && _picNodes.count <= 6) {
        
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
        
        ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
        
        ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
        
        ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
        
        ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:picPlayLayout];
        
        picButtonLayout = picInset;
        
    } else if (_picNodes.count > 6 && _picNodes.count <= 9) {
        
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
        
        ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
        
        
        ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:picPlayLayout];
        //            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
        
        picButtonLayout = picInset;
    }
    
    
    // 标签
    NSMutableArray *textNodesArr = [NSMutableArray array];
    NSMutableArray *horiNodeArr = [NSMutableArray array];
    CGFloat totalSingleWidth = 0;
    for (int i =  0 ; i < self.tagNodes.count ; i ++ ) {
        
        ASTextNode *node = self.tagNodes[i];
        
        CGRect nodeRect = [node frameForTextRange:NSMakeRange(0, node.attributedText.length)];
        CGFloat nodeWidth = nodeRect.size.width;
        CGFloat nodeHeight = nodeRect.size.height;
        node.style.preferredSize = CGSizeMake(nodeWidth, nodeHeight);
        
        if (totalSingleWidth + nodeWidth + 5 <= (kScreenWidth - kPicSpace * 2)) {
            
            [horiNodeArr addObject:node];
            totalSingleWidth += (5 + nodeWidth);
            
            if (i == self.tagNodes.count - 1) {
                
                NSArray *nodes = horiNodeArr.copy;
                ASStackLayoutSpec *horiStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:nodes];
                [textNodesArr addObject:horiStack];
            }
            
        } else {
            
            NSArray *nodes = horiNodeArr.copy;
            ASStackLayoutSpec *horiStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:nodes];
            
            horiNodeArr = [NSMutableArray array];
            totalSingleWidth = 0;
            [textNodesArr addObject:horiStack];
            
        }
        
    }
    
    ASStackLayoutSpec *textNodesStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:textNodesArr.copy];
    
    ASInsetLayoutSpec *tagsInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:textNodesStack];
    tagsInset.style.spacingBefore = 7;
    // 文字
    CGFloat textWidth = kScreenWidth - kPicSpace * 2;
    
    _proContentNode.style.flexShrink = 1;
    _proContentNode.style.width = ASDimensionMake(textWidth);
    
    // 小于三行隐藏遮罩和更多按钮
    // 获取文字属性
    CGRect contentFrame = [_allcontentNode frameForTextRange:(NSMakeRange(0, _allcontentNode.attributedText.length))];
    CGFloat width = contentFrame.size.width;
    CGFloat height = contentFrame.size.height;
    CGFloat singleHeight = height / (CGFloat)_allcontentNode.lineCount;
    ASInsetLayoutSpec *contentInset = nil;
    
#pragma mark - 判断多少行
    if ((width / (kScreenWidth - 2 * kPicSpace)) <= 2 && _allcontentNode.lineCount <= 2) {
        
        _shadowNode.hidden = YES;
        _moreButton.hidden = YES;
        
        ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:_proContentNode];
        
        contentInset = inset;
        
    } else {
        
        _shadowNode.style.spacingAfter = 0;
        _shadowNode.style.flexGrow = 1;
        //            _shadowNode.style.preferredSize = CGSizeMake(textWidth, kTextShadowHeight);
        //            _shadowNode.style.spacingBefore = kTextShadowInset;
        _moreButton.style.preferredSize = CGSizeMake(60, 40);
        
        if (_isOpen) {
            
            _moreButton.style.spacingBefore = kOpenMoreButtonPadding;
            
        } else {
            _moreButton.style.spacingBefore = kNoOpenMoreButtonPadding;
            
        }
        // 渐变
        
        ASInsetLayoutSpec *shadowInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(singleHeight * 2, 0, 0, 0)) child:_shadowNode];
        
        ASOverlayLayoutSpec *contentOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_proContentNode overlay:shadowInset];
        
        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[contentOverlay,_moreButton]];
        ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, kPicSpace, 0, kPicSpace)) child:contentShadow];
        contentInset = inset;
    }
    
    contentInset.style.spacingBefore = 7;
    contentInset.style.spacingAfter = 7;
    
    // 底部控件
    _lineNode.style.height = ASDimensionMake(1);
    _lineNode.style.spacingBefore = 0;
    
    _likeButton.style.spacingBefore = 13;
    _commentButton.style.spacingBefore = 10;
    
    _moneyButton.style.spacingAfter = 0;
    _shareButton.style.spacingBefore = 10;
    
    _setbutton.style.preferredSize = CGSizeMake(30, 20);

    
    ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:8 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeButton,_commentButton,_shareButton]];
    
    ASStackLayoutSpec *moneyLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_moneyButton,_setbutton]];
    
    ASStackLayoutSpec *downLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[likeLayout,moneyLayout]];
    
    downLayout.style.spacingBefore = 19;
    
    downLayout.style.spacingAfter = 19;
    
    // 全部布局
    ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upLayout,picButtonLayout,tagsInset,contentInset,_lineNode,downLayout]];
    
    
    ASBackgroundLayoutSpec *backLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:centerLayout background:_backNode];
    
    _backNode.shadowColor = [UIColor blackColor].CGColor;
    _backNode.shadowOffset = CGSizeMake(0, 0);
    _backNode.shadowOpacity = 0.1;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 11, 0)) child:backLayout];
    
        
}

//#if USE_CUSTOM_LAYOUT_TRANSITION

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context
{
    ASDisplayNode *fromNode = [[context removedSubnodes] objectAtIndex:0];
    ASDisplayNode *toNode = [[context insertedSubnodes] objectAtIndex:0];
    
    ASButtonNode *buttonNode = nil;
    for (ASDisplayNode *node in [context subnodesForKey:ASTransitionContextToLayoutKey]) {
        if ([node isKindOfClass:[ASButtonNode class]]) {
            buttonNode = (ASButtonNode *)node;
            break;
        }
    }
    
    CGRect toNodeFrame = [context finalFrameForNode:toNode];
    //    toNodeFrame.origin.x += (self.isOpen ? toNodeFrame.size.width : -toNodeFrame.size.width);
    toNode.frame = toNodeFrame;
    toNode.alpha = 0.0;
    
    CGRect fromNodeFrame = fromNode.frame;
    //    fromNodeFrame.origin.x += (self.isOpen ? -fromNodeFrame.size.width : fromNodeFrame.size.width);
    
    // We will use the same transition duration as the default transition
    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^{
        toNode.frame = [context finalFrameForNode:toNode];
        toNode.alpha = 1.0;
        
        fromNode.frame = fromNodeFrame;
        fromNode.alpha = 0.0;
        
        // Update frame of self
        CGSize fromSize = [context layoutForKey:ASTransitionContextFromLayoutKey].size;
        CGSize toSize = [context layoutForKey:ASTransitionContextToLayoutKey].size;
        BOOL isResized = (CGSizeEqualToSize(fromSize, toSize) == NO);
        if (isResized == YES) {
            CGPoint position = self.frame.origin;
            self.frame = CGRectMake(position.x, position.y, toSize.width, toSize.height);
        }
        
        buttonNode.frame = [context finalFrameForNode:buttonNode];
    } completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}


@end
