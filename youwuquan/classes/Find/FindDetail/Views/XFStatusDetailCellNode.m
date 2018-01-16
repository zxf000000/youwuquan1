//
//  XFStatusDetailCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusDetailCellNode.h"
#import "UIImage+ImageEffects.h"
#import "XFNetworkImageNode.h"

@implementation XFStatusDetailCollectionCellnode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _iconNode = [ASNetworkImageNode new];
        _iconNode.defaultImage = [UIImage imageNamed:@"zhanweitu44"];
        
//        _iconNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
//
//            UIGraphicsBeginImageContext(image.size);
//
//            UIBezierPath *path = [UIBezierPath
//                                  bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height)
//                                  cornerRadius:MIN(image.size.width,image.size.height)/2];
//
//            [path addClip];
//
//            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//
//            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
//
//            UIGraphicsEndImageContext();
//
//            return refinedImg;
//
//        };
        
        _iconNode.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubnode:_iconNode];

    }
    
    
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _iconNode.style.preferredSize = CGSizeMake(29, 29);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_iconNode];
    
}

@end

@implementation XFStatusDetailCellNode

- (instancetype)initWithModel:(XFStatusModel *)status likeDatas:(NSArray *)likeDatas {

    if (self = [super init]) {
        
        _status = status;
        
        _likeimgs = likeDatas;
        
        self.backgroundColor = UIColorHex(f4f4f4);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.shadowColor = UIColorHex(040000).CGColor;
        _bgNode.shadowOffset = CGSizeMake(0, 0);
        _bgNode.shadowOpacity = 0.1;
        _bgNode.cornerRadius = 4;
        [self addSubnode:_bgNode];
        
        _iconNode = [ASNetworkImageNode new];
        _iconNode.URL = [NSURL URLWithString:_status.user[@"headIconUrl"]];
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
        
        // TODO:
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:_status.user[@"nickname"]?_status.user[@"nickname"] : [XFUserInfoManager sharedManager].userInfo[@"info"][@"nickname"]];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        _timeNode = [[ASTextNode alloc] init];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_status.createTime longValue]/1000];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [format stringFromDate:date];
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString  alloc] initWithString:dateStr];
        
        timeStr.attributes = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:11],
                               NSForegroundColorAttributeName:UIColorHex(868383)
                               };
        
        _timeNode.attributedText = timeStr;
        
        _timeNode.maximumNumberOfLines = 1;
        [self addSubnode:_timeNode];
        // 关注
        _followButton = [[ASButtonNode alloc] init];
        [_followButton setTitle:@"+ 关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_followButton setTitle:@"已关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        
        _followButton.selected = [_status.user[@"followed"] boolValue] ? YES : NO;
        
        if (_followButton.selected) {
            
            [_followButton setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            
            _followButton.backgroundColor = [UIColor lightGrayColor];
            
        } else {
            [_followButton setBackgroundImage:[UIImage imageNamed:@"find_careBg"] forState:(UIControlStateNormal)];
            
            _followButton.backgroundColor = kMainRedColor;
            
        }

        
        [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        
        [self addSubnode:_followButton];
        
        // 动态内容
        _commentNode = [[ASTextNode alloc] init];
        
        [_commentNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_status.text?_status.text:@"数据错误" lineSpace:4 kern:1];
        
        [self addSubnode:_commentNode];
        
        // 动态图片
        NSMutableArray *noteImgs = [NSMutableArray array];
        _imageNodes = [NSMutableArray array];

        NSArray *openImg = _status.pictures;
        [noteImgs addObjectsFromArray:openImg];

        _allImgs = noteImgs.copy;
        
        // 判断是否是视频
        
        if (_allImgs.count > 0) {
            
            for (NSInteger i = 0 ; i < noteImgs.count ; i ++ ) {
                
                NSDictionary *imgInfo = noteImgs[i];

                XFNetworkImageNode *imageNode = [[XFNetworkImageNode alloc] init];
                imageNode.image = [UIImage imageNamed:@"zhanweitu33"];
                imageNode.url = [NSURL URLWithString:imgInfo[@"image"][@"imageUrl"]];
                imageNode.contentMode = UIViewContentModeScaleToFill;
                
                [imageNode addTarget:self action:@selector(selectedPicWithImage:) forControlEvents:(ASControlNodeEventTouchUpInside)];
                
                [self addSubnode:imageNode];
                [_imageNodes addObject:imageNode];
                
            }
        } else {
            
            NSDictionary *videoInfo = _status.video;
            
            XFNetworkImageNode *imageNode = [[XFNetworkImageNode alloc] init];
            imageNode.image = [UIImage imageNamed:@"zhanweitu33"];
            imageNode.url = [NSURL URLWithString:videoInfo[@"video"][@"coverUrl"]];
            
            imageNode.contentMode = UIViewContentModeScaleToFill;
            
            [imageNode addTarget:self action:@selector(selectedPicWithImage:) forControlEvents:(ASControlNodeEventTouchUpInside)];
            
            [self addSubnode:imageNode];
            [_imageNodes addObject:imageNode];
        }
        
        _playButton = [[ASButtonNode alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"video_play"] forState:(UIControlStateNormal)];
        [self addSubnode:_playButton];
        
        if (_status.video) {
            
            _playButton.hidden = NO;
            
        } else {
            
            _playButton.hidden = YES;
        }
        
        // 底部
        _numberNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *number = [[NSMutableAttributedString  alloc] initWithString:[NSString stringWithFormat:@"%@ 浏览",_status.viewNum ? _status.viewNum : @"0"]];
        
        number.attributes = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:11],
                              NSForegroundColorAttributeName:UIColorHex(868383)
                              };
        
        _numberNode.attributedText = number;
        
        _numberNode.maximumNumberOfLines = 1;
        [self addSubnode:_numberNode];
        
        
        _likeNode = [[ASButtonNode alloc] init];
        [_likeNode setTitle:[NSString stringWithFormat:@"%@",_status.likeNum] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [_likeNode setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        
        _likeNode.selected = _status.likedIt;
        
        [_likeNode addTarget:self action:@selector(clickLikeButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [self addSubnode:_likeNode];
        
        _contentNode = [[ASButtonNode alloc] init];
        [_contentNode setTitle:[NSString stringWithFormat:@"%@",_status.commentNum] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_contentNode setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];
        [self addSubnode:_contentNode];
        
        _lineNode = [[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = UIColorHex(f4f4f4);
        [self addSubnode:_lineNode];
        
        // 点赞的人的头像
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat padding = (kScreenWidth - 290)/11.f;
        layout.minimumLineSpacing = padding;
        layout.minimumInteritemSpacing = padding;
        layout.sectionInset = UIEdgeInsetsMake(10, padding, 10, padding);
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        [self addSubnode:_collectionNode];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [_iconNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        [_nameNode addTarget:self action:@selector(clickIconNode) forControlEvents:(ASControlNodeEventTouchUpInside)];


    }
    
    return self;
}

- (void)clickIconNode {
    
    [self.detailDelegate statusCellNode:self didClickIconNode:self.iconNode];
}

#pragma mark - 点击事件
- (void)clickFollowButton:(ASButtonNode *)button {
    
    [self.detailDelegate statusCellNode:self didClickFollowButton:button];


    

    
}

- (void)clickLikeButton {
    
    [self.detailDelegate statusCellNode:self didClickLikeButton:self.likeNode];

}

- (void)selectedPicWithImage:(ASNetworkImageNode *)picNode {
    
    XFNetworkImageNode *imageNode = picNode.supernode;
    
    NSInteger index = [self.imageNodes indexOfObject:imageNode];
    
    
    [self.detailDelegate statusCellNode:self didSelectedPicWithIndex:index pics:self.images picnodes:self.imageNodes];
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return self.likeimgs.count + 1;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode *{
        
        XFStatusDetailCollectionCellnode *node = [[XFStatusDetailCollectionCellnode alloc] init];
        
        
        if (indexPath.item == 0) {
            
            node.iconNode.defaultImage = [UIImage imageNamed:@"home_liked"];
            node.iconNode.contentMode = UIViewContentModeCenter;

            
        } else {
            
            NSDictionary *dic = self.likeimgs[indexPath.item - 1];

            node.iconNode.URL = [NSURL URLWithString:dic[@"headIconUrl"]];
            node.clipsToBounds = YES;
            node.cornerRadius = 14.5;
        }
        
        return node;
        
    };
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    if (self.allImgs.count > 0 || _status.video) {
    
        _iconNode.style.preferredSize = CGSizeMake(45, 45);
        _iconNode.style.spacingBefore = 13;
        _iconNode.style.flexGrow = 0;
        _iconNode.style.flexGrow = 0;
        _iconNode.style.flexBasis = ASDimensionAuto;
        _iconNode.style.flexShrink = 0;
        
        _nameNode.style.spacingBefore = 5;
        _nameNode.style.flexShrink = YES;
        _nameNode.style.preferredSize = CGSizeMake(100, 20);
        
        _followButton.style.spacingAfter = 8;
        _followButton.style.spacingAfter = 19;
        
        _followButton.style.preferredSize = CGSizeMake(70, 29);
        _followButton.cornerRadius = 3;
        
        
        if (_status.video) {
            
            for (NSInteger i = 0 ; i< self.imageNodes.count ; i ++ ) {
                
                ASNetworkImageNode *imgNode = self.imageNodes[i];
                
                CGFloat imgWidth = kScreenWidth - 20;
                CGFloat imgHeight = imgWidth * 9 / 16.f;
                imgNode.style.preferredSize = CGSizeMake(imgWidth, imgHeight);
                
                imgNode.cornerRadius = 20;
                imgNode.clipsToBounds = YES;
                
            }
            
        } else {
            
            
            for (NSInteger i = 0 ; i< self.allImgs.count ; i ++ ) {
                
                NSDictionary *imgInfo = self.allImgs[i];
                ASNetworkImageNode *imgNode = self.imageNodes[i];
                
                CGSize size = CGSizeMake([imgInfo[@"image"][@"width"] intValue], [imgInfo[@"image"][@"height"] intValue]);
                
                CGFloat imgWidth = kScreenWidth - 20;
                CGFloat imgHeight = imgWidth * size.height/size.width;
                imgNode.style.preferredSize = CGSizeMake(imgWidth, imgHeight);
                
                imgNode.cornerRadius = 20;
                imgNode.clipsToBounds = YES;
                
            }
        }
        
        CGFloat imgWidth = kScreenWidth - 20;
        CGFloat imgHeight = imgWidth * 9 / 16.f;

        // 名字和时间
        ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,_timeNode]];
        
        // 名字和头像
        ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
        
        // 上面一层
        ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];
        
        ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:upLayout];
        
        ASInsetLayoutSpec *commentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:_commentNode];
        
        ASStackLayoutSpec *imglayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:self.imageNodes];
        
        ASInsetLayoutSpec *insetPLay = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake((imgHeight - 50)/2, (imgWidth - 100)/2, (imgHeight - 50)/2, (imgWidth - 100)/2)) child:_playButton];
        
        ASOverlayLayoutSpec *imgOverLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imglayout overlay:insetPLay];
        
        // 点赞按钮层
        ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeNode,_contentNode]];
        
        ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_numberNode,likeLayout]];
        
        ASInsetLayoutSpec *centerInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(20, 10, 15, 10)) child:centerLayout];
        
        _lineNode.style.preferredSize = CGSizeMake(kScreenWidth - 30, 1);
        
        // 点赞拖箱
        NSInteger lineCount = 0;
        if ((self.likeimgs.count + 1)%10 == 0) {
            lineCount = (self.likeimgs.count + 1)/10;
            
        } else {
            
            lineCount = (self.likeimgs.count + 1)/10 + 1;
            
        }
        
        _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, lineCount * 29 + (lineCount - 1) * (kScreenWidth - 290)/11.f + 20);
        
        ASInsetLayoutSpec *lineInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 15, 0, 15)) child:_lineNode];
        
        ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,commentInset, imgOverLay,centerInset,lineInset,_collectionNode]];
        
        ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:alllayout background:_bgNode];
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
        
    }

    _iconNode.style.preferredSize = CGSizeMake(45, 45);
    _iconNode.style.spacingBefore = 13;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexBasis = ASDimensionAuto;
    _iconNode.style.flexShrink = 0;

    _nameNode.style.spacingBefore = 5;
    _nameNode.style.flexShrink = YES;
    _nameNode.style.preferredSize = CGSizeMake(100, 20);

    _followButton.style.spacingAfter = 8;
    _followButton.style.spacingAfter = 19;

    _followButton.style.preferredSize = CGSizeMake(70, 29);
    _followButton.cornerRadius = 3;

    // 名字和时间
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,_timeNode]];

    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];



    // 上面一层
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];

    ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:upLayout];

    ASInsetLayoutSpec *commentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:_commentNode];

//    ASStackLayoutSpec *imglayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:self.imageNodes];

//    ASInsetLayoutSpec *insetPLay = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake((imgHeight - 50)/2, (imgWidth - 100)/2, (imgHeight - 50)/2, (imgWidth - 100)/2)) child:_playButton];

//    ASOverlayLayoutSpec *imgOverLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imglayout overlay:insetPLay];

    // 点赞按钮层
    ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_likeNode,_contentNode]];

    ASStackLayoutSpec *centerLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_numberNode,likeLayout]];

    ASInsetLayoutSpec *centerInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(20, 10, 15, 10)) child:centerLayout];

    _lineNode.style.preferredSize = CGSizeMake(kScreenWidth - 30, 1);

    // 点赞拖箱
    NSInteger lineCount = 0;
    if ((self.likeimgs.count + 1)%10 == 0) {
        lineCount = (self.likeimgs.count + 1)/10;

    } else {

        lineCount = (self.likeimgs.count + 1)/10 + 1;

    }

    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, lineCount * 29 + (lineCount - 1) * (kScreenWidth - 290)/11.f + 20);

    ASInsetLayoutSpec *lineInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 15, 0, 15)) child:_lineNode];

    ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,commentInset,centerInset,lineInset,_collectionNode]];

    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:alllayout background:_bgNode];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
    
}

@end
