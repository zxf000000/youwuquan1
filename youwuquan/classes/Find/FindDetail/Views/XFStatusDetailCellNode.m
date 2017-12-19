//
//  XFStatusDetailCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusDetailCellNode.h"

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

- (instancetype)initWithModel:(XFStatusModel *)status {
    
    if (self = [super init]) {
        
        _status = status;
        
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
        _iconNode.defaultImage = [UIImage imageNamed:kRandomIcon];
        _iconNode.URL = [NSURL URLWithString:_status.headUrl];
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
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:_status.userNike];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        _timeNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString  alloc] initWithString:_status.createTime];
        
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
        
        _followButton.backgroundColor = UIColorHex(F72F5E);
        
        [self addSubnode:_followButton];
        
        // 动态内容
        _commentNode = [[ASTextNode alloc] init];
        
        [_commentNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_status.title lineSpace:4 kern:1];
        
        [self addSubnode:_commentNode];
        
        // 动态图片
        NSMutableArray *noteImgs = [NSMutableArray array];
        NSMutableArray *imageNodes = [NSMutableArray array];

        NSArray *openImg = _status.openImageList;
        NSArray *secImg = _status.intimateImageList;
        [noteImgs addObjectsFromArray:openImg];
        [noteImgs addObjectsFromArray:secImg];

        _allImgs = noteImgs.copy;
        
        for (NSInteger i = 0 ; i < noteImgs.count ; i ++ ) {
            
            NSDictionary *imgInfo = noteImgs[i];
            
            ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
            imageNode.defaultImage = [UIImage imageNamed:@"zhanweitu33"];
            imageNode.URL = [NSURL URLWithString:imgInfo[@"breviaryUrl"]];
            
            imageNode.contentMode = UIViewContentModeScaleToFill;
            
            [imageNode addTarget:self action:@selector(selectedPicWithImage:) forControlEvents:(ASControlNodeEventTouchUpInside)];
            
            [self addSubnode:imageNode];
            [imageNodes addObject:imageNode];
            
        }
        _imageNodes = imageNodes.copy;
        
        // 底部
        _numberNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *number = [[NSMutableAttributedString  alloc] initWithString:@"111111浏览"];
        
        number.attributes = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:11],
                              NSForegroundColorAttributeName:UIColorHex(868383)
                              };
        
        _numberNode.attributedText = number;
        
        _numberNode.maximumNumberOfLines = 1;
        [self addSubnode:_numberNode];
        
        
        _likeNode = [[ASButtonNode alloc] init];
        [_likeNode setTitle:[NSString stringWithFormat:@"%@",_status.greatNum] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        [self addSubnode:_likeNode];
        
        _contentNode = [[ASButtonNode alloc] init];
        [_contentNode setTitle:[NSString stringWithFormat:@"%@",_status.messageNum] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
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

    }
    
    return self;
}


- (instancetype)initWithImages:(NSArray *)images likeImgs:(NSArray *)likeImgs {
    if (self = [super init]) {
        
        _images = images;
        _likeimgs = likeImgs;
        
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
//        _iconNode.delegate = self;
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
        
        _timeNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString  alloc] initWithString:@"2017-09-19 14:20"];
        
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
        
        _followButton.backgroundColor = UIColorHex(F72F5E);
        [self addSubnode:_followButton];
        
        // 动态内容
        _commentNode = [[ASTextNode alloc] init];
        
        [_commentNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:kRandomComment lineSpace:4 kern:1];
        
//        NSMutableAttributedString *comment = [[NSMutableAttributedString  alloc] initWithString:];
//        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//
//        paraStyle.lineSpacing = 5;
//
//        comment.attributes = @{
//                               NSFontAttributeName : ,
//                               NSForegroundColorAttributeName:UIColorHex(000000),
//                               NSParagraphStyleAttributeName:paraStyle,
//                               };
//
//        _commentNode.attributedText = comment;
//
//        _commentNode.maximumNumberOfLines = 0;
    
        [self addSubnode:_commentNode];
        
        // 动态图片
        NSMutableArray *noteImgs = [NSMutableArray array];
        for (NSInteger i = 0 ; i < _images.count ; i ++ ) {
            
            ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
            imageNode.defaultImage = [UIImage imageNamed:_images[i]];
            imageNode.contentMode = UIViewContentModeScaleToFill;
            
            [imageNode addTarget:self action:@selector(selectedPicWithImage:) forControlEvents:(ASControlNodeEventTouchUpInside)];
            
            [self addSubnode:imageNode];
            [noteImgs addObject:imageNode];
            
        }
        _imageNodes = noteImgs.copy;
        
        // 底部
        _numberNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *number = [[NSMutableAttributedString  alloc] initWithString:@"111111浏览"];
        
        number.attributes = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:11],
                               NSForegroundColorAttributeName:UIColorHex(868383)
                               };
        
        _numberNode.attributedText = number;
        
        _numberNode.maximumNumberOfLines = 1;
        [self addSubnode:_numberNode];
        
        
        _likeNode = [[ASButtonNode alloc] init];
        [_likeNode setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeNode setImage:[UIImage imageNamed:@"home_liked"] forState:(UIControlStateSelected)];
        [self addSubnode:_likeNode];
        
        _contentNode = [[ASButtonNode alloc] init];
        [_contentNode setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor blackColor] forState:(UIControlStateNormal)];
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

    
    }
    return self;
}

- (void)selectedPicWithImage:(ASNetworkImageNode *)picNode {
    
    NSInteger index = [self.imageNodes indexOfObject:picNode];
    
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
            
            node.iconNode.defaultImage = [UIImage imageNamed:kRandomIcon];
            node.clipsToBounds = YES;
            node.cornerRadius = 14.5;
        }
        
        return node;
        
    };
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    if (self.allImgs) {
        
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
        
        for (NSInteger i = 0 ; i< self.allImgs.count ; i ++ ) {
            
            NSDictionary *imgInfo = self.allImgs[i];
            ASNetworkImageNode *imgNode = self.imageNodes[i];
            
            CGSize size = CGSizeMake([imgInfo[@"imgWidth"] intValue], [imgInfo[@"imgHeight"] intValue]);
            CGFloat imgWidth = kScreenWidth - 20;
            CGFloat imgHeight = imgWidth * size.height/size.width;
            imgNode.style.preferredSize = CGSizeMake(imgWidth, imgHeight);
            
            imgNode.cornerRadius = 20;
            imgNode.clipsToBounds = YES;
            
        }
        
        // 名字和时间
        ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,_timeNode]];
        
        // 名字和头像
        ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
        
        // 上面一层
        ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];
        
        ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:upLayout];
        
        ASInsetLayoutSpec *commentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:_commentNode];
        
        ASStackLayoutSpec *imglayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:self.imageNodes];
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
        
        ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,commentInset, imglayout,centerInset,lineInset,_collectionNode]];
        
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

    for (NSInteger i = 0 ; i < self.imageNodes.count ; i ++ ) {
        
        ASNetworkImageNode *imgNode = self.imageNodes[i];
        
        UIImage *img = imgNode.image;
        
        CGSize size = img.size;
        CGFloat imgWidth = kScreenWidth - 20;
        CGFloat imgHeight = imgWidth * size.height/size.width;
        imgNode.style.preferredSize = CGSizeMake(imgWidth, imgHeight);
        
        imgNode.cornerRadius = 20;
        imgNode.clipsToBounds = YES;
        
    }
    
    // 名字和时间
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,_timeNode]];
    
    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
    
    // 上面一层
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];
    
    ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 0, 0)) child:upLayout];
    
    ASInsetLayoutSpec *commentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:_commentNode];
    
    ASStackLayoutSpec *imglayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:self.imageNodes];
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
    
    ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,commentInset, imglayout,centerInset,lineInset,_collectionNode]];
    
    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:alllayout background:_bgNode];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
    
}

@end
