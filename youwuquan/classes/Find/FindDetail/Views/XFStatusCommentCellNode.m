//
//  XFStatusCommentCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusCommentCellNode.h"

@implementation XFStatusCommentCellNode

- (instancetype)init {
    
    if (self = [super init]) {
        
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
        
        _commentNode = [[ASTextNode alloc] init];

        NSMutableAttributedString *comment = [[NSMutableAttributedString  alloc] initWithString:kRandomPl];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        
        paraStyle.lineSpacing = 5;
        
        comment.attributes = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName:UIColorHex(000000),
                               NSParagraphStyleAttributeName:paraStyle,
                               };
        
        _commentNode.attributedText = comment;
        
        _commentNode.maximumNumberOfLines = 0;
        
        [_commentNode addTarget:self action:@selector(clickCommentNode) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [self addSubnode:_commentNode];
        
        _lineNode = [[ASDisplayNode alloc] init];
        _lineNode.backgroundColor = UIColorHex(f4f4f4);
        [self addSubnode:_lineNode];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}


- (void)clickCommentNode {

    if ([self.delegate respondsToSelector:@selector(statusCommentNode:didClickComplyTextWithIndex:)]) {
        
        [self.delegate statusCommentNode:self didClickComplyTextWithIndex:self.indexPath];
        
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _iconNode.style.preferredSize = CGSizeMake(45, 45);
    _iconNode.style.spacingBefore = 13;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexGrow = 0;
    _iconNode.style.flexBasis = ASDimensionAuto;
    _iconNode.style.flexShrink = 0;
    
    _nameNode.style.spacingBefore = 5;
    _nameNode.style.flexShrink = YES;
    _nameNode.style.preferredSize = CGSizeMake(100, 20);
    
    _commentNode.style.width = ASDimensionMake(kScreenWidth - 45 - 10 - 10 - 20);
    _lineNode.style.preferredSize = CGSizeMake(kScreenWidth - 30, 1);

    // 名字和时间
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode,_timeNode,_commentNode]];
    
    
    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_iconNode,nameIconLayout]];
    
    ASInsetLayoutSpec *allInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 10, 0)) child:iconNameLayout];

    
    ASStackLayoutSpec *all = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[allInset,[ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 30, 0, 0)) child:_lineNode]]];
    
    
    return all;
    
}

@end
