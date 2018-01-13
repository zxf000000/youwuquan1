//
//  XFFindCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindCellNode.h"
#import "XFIconmanager.h"
#import "UIImage+ImageEffects.h"
#import "XFAuthManager.h"

#define kTextShadowHeight 16
#define kTextShadowInset -16
#define kOpenMoreButtonPadding 0
#define kNoOpenMoreButtonPadding 0

@implementation XFFindCellNode

- (instancetype)initWithType:(FindCellType)type pics:(NSArray *)pics open:(BOOL)isOpen model:(XFStatusModel *)model {
    
    if (self  = [super init]) {

        _pics = pics;
        _type = type;
        _isOpen = isOpen;
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
        
        _playButton = [[ASButtonNode alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"video_play"] forState:(UIControlStateNormal)];
        [self addSubnode:_playButton];
        // 图像
        if (_model.video) {
            
            XFNetworkImageNode *picNode = [[XFNetworkImageNode alloc] init];
            picNode.image = [UIImage imageNamed:@"zhanweitu22"];
            picNode.url = [NSURL URLWithString:_model.video[@"video"][@"coverUrl"]];
            picNode.cornerRadius = 10;
            picNode.clipsToBounds = YES;
            [self addSubnode:picNode];
            _picNodes = @[picNode];
            
            
        } else {
            
            NSMutableArray *nodes = [NSMutableArray array];
            for (NSInteger i = 0 ; i < _model.pictures.count ; i ++ ) {
                
                XFNetworkImageNode *picNode = [[XFNetworkImageNode alloc] init];
                NSDictionary *info = _model.pictures[i];
                picNode.image = [UIImage imageNamed:@"zhanweitu22"];
                picNode.url = [NSURL URLWithString:info[@"image"][@"thumbImage300pxUrl"] ? info[@"image"][@"thumbImage300pxUrl"] : @"1212121212"];
                picNode.cornerRadius = 10;
                picNode.clipsToBounds = YES;
                [self addSubnode:picNode];
                [nodes addObject:picNode];
                
            }
            _picNodes = nodes.copy;
            _playButton.hidden = YES;
            
        }
        
        _playButton = [[ASButtonNode alloc] init];
        
        [_playButton setImage:[UIImage imageNamed:@"video_play"] forState:(UIControlStateNormal)];
        
        [self addSubnode:_playButton];
        
        if (_model.video) {
            
            _playButton.hidden = NO;
            
        } else {
            
            _playButton.hidden = YES;
            
            
        }
        // 图像遮罩
        _imgShadowNode = [[ASImageNode alloc] init];
        [self addSubnode:_imgShadowNode];
        
        // 打赏
        _rewardButton = [[ASButtonNode alloc] init];
        
        [_rewardButton setImage:[UIImage imageNamed:@"find_rewardbg"] forState:(UIControlStateNormal)];

        [self addSubnode:_rewardButton];
        
        // 文字
        _contentNode = [[ASTextNode alloc] init];
        [_contentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.text?_model.text:@"数据错误" lineSpace:4 kern:1];
        _contentNode.maximumNumberOfLines = 2;
        [self addSubnode:_contentNode];
        // 文字
        _allcontentNode = [[ASTextNode alloc] init];
        [_allcontentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.text?_model.text:@"数据错误" lineSpace:4 kern:1];
        _allcontentNode.maximumNumberOfLines =0;
        _allcontentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_allcontentNode];
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
        [_timeNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[XFToolManager changeLongToDateWith:_model.createTime] lineSpace:2 kern:1];
        
        [self addSubnode:_timeNode];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:[NSString stringWithFormat:@"%@",_model.likeNum] withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        
        _likeButton.selected = model.likedIt;

        [self addSubnode:_likeButton];
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:[NSString stringWithFormat:@"%@",_model.commentNum] withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
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

- (instancetype)initWithOpen:(BOOL)open pics:(NSArray *)pics model:(XFStatusModel *)model {
    
    if (self  = [super init]) {
        
        _model = model;
        
        _type = List;

        _isOpen = open;
        
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
        
        _iconNode = [[XFNetworkImageNode alloc] init];
        _iconNode.url = [NSURL URLWithString:_model.user[@"headIconUrl"]];
        _iconNode.cornerRadius = 22.5;
        _iconNode.clipsToBounds = YES;
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        // TODO:
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:_model.user[@"nickname"] ? _model.user[@"nickname"] : @"数据错误"];
        
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
        [_approveButton setBackgroundImage:[UIImage imageNamed:@"find_careBg"] forState:(UIControlStateNormal)];

        _approveButton.backgroundColor = UIColorHex(F72F5E);
        // TODO:

        _approveButton.selected = [_model.user[@"followed"] boolValue] ? YES : NO;
        
        if (_approveButton.selected) {
            
            [_approveButton setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            
            _approveButton.backgroundColor = [UIColor lightGrayColor];
            
        } else {
            [_approveButton setBackgroundImage:[UIImage imageNamed:@"find_careBg"] forState:(UIControlStateNormal)];
            
            _approveButton.backgroundColor = kMainRedColor;
            
        }
        
        [self addSubnode:_approveButton];
        
        // 分享
        _shareButton = [[ASButtonNode alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
        
        [self addSubnode:_shareButton];
        
        // 图像

        // 图像
        if (_model.video) {
            
                ASNetworkImageNode *picNode = [[ASNetworkImageNode alloc] init];
            picNode.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
                picNode.URL = [NSURL URLWithString:_model.video[@"video"][@"coverUrl"]];
                picNode.cornerRadius = 10;
                picNode.clipsToBounds = YES;
                [self addSubnode:picNode];
                _picNodes = @[picNode];
            

        } else {
            
            NSMutableArray *nodes = [NSMutableArray array];
            for (NSInteger i = 0 ; i < _model.pictures.count ; i ++ ) {
                
                XFNetworkImageNode *picNode = [[XFNetworkImageNode alloc] init];
                NSDictionary *info = _model.pictures[i];
                picNode.image = [UIImage imageNamed:@"zhanweitu22"];
                picNode.url = [NSURL URLWithString:info[@"image"][@"thumbImage300pxUrl"]];
                picNode.cornerRadius = 10;
                picNode.clipsToBounds = YES;
                [self addSubnode:picNode];
                [nodes addObject:picNode];
                
//                ASNetworkImageNode *picNode = [[ASNetworkImageNode alloc] init];
//                NSDictionary *info = _model.pictures[i];
//                picNode.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
//                picNode.URL = [NSURL URLWithString:info[@"image"][@"thumbImage300pxUrl"]];
//                picNode.cornerRadius = 10;
//                picNode.clipsToBounds = YES;
//
//                [self addSubnode:picNode];
//                [nodes addObject:picNode];
                
            }
            _picNodes = nodes.copy;
            
        }
        
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
        [self addSubnode:_imgShadowNode];
        
        // 打赏
        _rewardButton = [[ASButtonNode alloc] init];

        [_rewardButton setImage:[UIImage imageNamed:@"find_rewardbg"] forState:(UIControlStateNormal)];
//        _rewardButton.borderColor = [UIColor whiteColor].CGColor;
//        _rewardButton.borderWidth = 2;
        [self addSubnode:_rewardButton];
        
        // 文字
        _contentNode = [[ASTextNode alloc] init];
        [_contentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.text?_model.text:@"加载出错了" lineSpace:4 kern:1];
        _contentNode.maximumNumberOfLines =2;
        _contentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_contentNode];
        
        // 文字
        _allcontentNode = [[ASTextNode alloc] init];
        [_allcontentNode setFont:[UIFont systemFontOfSize:13] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.text?_model.text:@"加载出错了" lineSpace:4 kern:1];
        _allcontentNode.maximumNumberOfLines =0;
        _allcontentNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_allcontentNode];
        
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
        
        NSLog(@"%@-",_model.createTime);
        
        [_timeNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:[XFToolManager changeLongToDateWith:_model.createTime] lineSpace:2 kern:0];
        
        [self addSubnode:_timeNode];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:_model.likeNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        
        _likeButton.selected = model.likedIt;
        
        [self addSubnode:_likeButton];
        
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:_model.commentNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];

        [self addSubnode:_commentButton];
        
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
//
//            ASImageNode *iconNode = [[ASImageNode alloc] init];
//
//            iconNode.image = [UIImage imageNamed:[XFIconmanager sharedManager].authIcons[i]];
            
        }
        
        _authenticationIcons = icons.copy;
        
        [_likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_approveButton addTarget:self action:@selector(clickApproveButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_iconNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_nameNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_rewardButton addTarget:self action:@selector(clickRewardButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [_shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
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

// 分享
- (void)clickShareButton {
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickShareButtonWithIndex:)]) {
        
        [self.delegate findCellNode:self didClickShareButtonWithIndex:self.indexPath];
        
    }
    
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
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickFollowButtonWithIndex:)]) {
        
        [self.delegate findCellNode:self didClickFollowButtonWithIndex:self.indexPath];
    }

}
// 点赞
- (void)clickLikeButton {
    
    if ([self.delegate respondsToSelector:@selector(findCellNode:didClickLikeButtonForIndex:)]) {
        
        [self.delegate findCellNode:self didClickLikeButtonForIndex:self.indexPath];
    }
    
}
// 展开
- (void)clickMoreButton:(ASButtonNode *)sender {
    
    sender.selected = !sender.isSelected;
//
    self.defaultLayoutTransitionDuration = 0.1;

    
//    [self.delegate findCellclickMpreButtonWithIndex:self.indexPath open:sender.selected];
//
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


    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:NO measurementCompletion:^{


        [self setNeedsLayout];

    }];
    

}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

//    if (self.isOpen) {
//
//        self.contentNode.maximumNumberOfLines = 0;
//
//    } else {
//
//        self.contentNode.maximumNumberOfLines = 2;
//
//    }
    if (self.isOpen) {
        
        self.proContentNode = self.allcontentNode;
        
    } else {
        
        self.proContentNode = self.contentNode;
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
        
        _approveButton.style.spacingAfter = 0;
        _approveButton.style.preferredSize = CGSizeMake(70, 28);
        _approveButton.cornerRadius = 3;
        _shareButton.style.spacingAfter = 0;
        _shareButton.style.preferredSize = CGSizeMake(40, 30);
        _shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 30);
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

        if (_picNodes.count == 1) {
            
            ASNetworkImageNode *picNode = self.picNodes[0];

            CGSize imgSize;
            if (_model.video) {
                
                imgSize = CGSizeMake(picWidth, picWidth * 19/35.f);
                
            } else {
                
                NSDictionary *picInfo = _model.pictures[0];
                imgSize = CGSizeMake([picInfo[@"image"][@"width"] floatValue], [picInfo[@"image"][@"height"] floatValue]);
                
            }
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
            
            _playButton.style.preferredSize = CGSizeMake(80, 80);
            
            ASInsetLayoutSpec *insetPlay = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake((picHeight - 80)/2, (picWidth - 80)/2, (picHeight - 80)/2, (picWidth - 80)/2)) child:_playButton];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:insetPlay];
            
            ASInsetLayoutSpec *picInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, -leftInset, 0, 0)) child:picPlayLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picInset,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_picNodes.count == 4) {
            
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
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];

            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_picNodes.count == 2) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(middlePicWidth, middlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  0 * (3 - _picNodes.count), 0,0)) child:upPicLayout];
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];

            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
            
        } else if (_picNodes.count > 1 && _picNodes.count <= 3) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  -littlePicWidth * (3 - _picNodes.count), 0,0)) child:upPicLayout];

            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];

            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
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
            
            //            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) flexWrap:(ASStackLayoutFlexWrapNoWrap) alignContent:(ASStackLayoutAlignContentStretch) children:@[upPicLayout,downPicLayout]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];

            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
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

            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
        }
        

        
        
        CGFloat textWidth = kScreenWidth - 20 - 36;
        
        // 文字
        _proContentNode.style.flexShrink = 1;
        _proContentNode.style.width = ASDimensionMake(textWidth);
        
        _shadowNode.style.spacingAfter = 0;
        _shadowNode.style.flexGrow = 1;
//        _shadowNode.style.preferredSize = CGSizeMake(textWidth, kTextShadowHeight);
//        _shadowNode.style.spacingBefore = kTextShadowInset;
        if (_isOpen) {
            
            _moreButton.style.spacingBefore = kOpenMoreButtonPadding;

        } else {
            _moreButton.style.spacingBefore = kNoOpenMoreButtonPadding;
            _contentNode.style.height = ASDimensionMake(25);

            
        }
        _moreButton.style.preferredSize = CGSizeMake(60, 40);
        // 渐变
        
        ASInsetLayoutSpec *shadowInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:_shadowNode];
        
        ASOverlayLayoutSpec *contentOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_proContentNode overlay:shadowInset];
        
//        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_proContentNode,_shadowNode,_moreButton]];
        
        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[contentOverlay,_moreButton]];

        
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
        
        if (_picNodes.count == 1) {
            
            XFNetworkImageNode *picNode = self.picNodes[0];
            CGSize imgSize = picNode.image.size;
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
            
            ASInsetLayoutSpec *insetPlay = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake((picHeight - 80)/2, (picWidth - 80)/2, (picHeight - 80)/2, (picWidth - 80)/2)) child:_playButton];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picInset overlay:insetPlay];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_picNodes.count == 2) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(middlePicWidth, middlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  0 * (3 - _picNodes.count), 0,0)) child:upPicLayout];
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
            
        } else if (_picNodes.count == 4) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(middlePicWidth, middlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[0],_picNodes[1]]];
            ASStackLayoutSpec *downPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_picNodes[2],_picNodes[3]]];
            
            ASStackLayoutSpec *picsLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[upPicLayout,downPicLayout]];
            
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  0, 0,0)) child:picsLayout];
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
        } else if (_picNodes.count > 1 && _picNodes.count <= 3) {
            
            for (ASNetworkImageNode *picNode in _picNodes) {
                picNode.style.preferredSize = CGSizeMake(littlePicWidth, littlePicWidth);
                
            }
            
            ASStackLayoutSpec *upPicLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:_picNodes];
            
            ASInsetLayoutSpec *picINset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0,  -littlePicWidth * (3 - _picNodes.count), 0,0)) child:upPicLayout];
            
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picINset overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
            
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
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


            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
            
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
            
            
            ASInsetLayoutSpec *picShadowLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(littlePicWidth * 2 - picShadowHeight, 0, 0, 0)) child:_imgShadowNode];
            
            ASOverlayLayoutSpec *picLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picsLayout overlay:picShadowLayout];
            
            ASOverlayLayoutSpec *picPlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:picLayout overlay:_playButton];
//
            ASStackLayoutSpec *picButtonLayou = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:-40 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[picPlayLayout,_rewardButton]];
            
            picButtonLayout = picButtonLayou;
        }
        
        // 文字
        // 文字

        _proContentNode.style.width = ASDimensionMake(picWidth-36);
        _proContentNode.style.flexShrink = 1;
        
        _shadowNode.style.spacingAfter = 0;
        _shadowNode.style.flexGrow = 1;
        
        if (_isOpen) {
            
            _moreButton.style.spacingBefore = kOpenMoreButtonPadding;
            
        } else {
            _moreButton.style.spacingBefore = kNoOpenMoreButtonPadding;
            
            _contentNode.style.height = ASDimensionMake(25);

        }
        _moreButton.style.preferredSize = CGSizeMake(60, 40);
        // 渐变
        
        ASInsetLayoutSpec *shadowInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:_shadowNode];
        
        ASOverlayLayoutSpec *contentOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_proContentNode overlay:shadowInset];
        
        ASStackLayoutSpec *contentShadow = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[contentOverlay,_moreButton]];
        
        
        ASInsetLayoutSpec *contentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 18, 0, 18)) child:contentShadow];
        
        // 如果是文字,要跟边界距离设置远一点
        if ([_model.type isEqualToString:@"word"]) {
            
            contentInset.style.spacingBefore = 20;
            
        }
        
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
