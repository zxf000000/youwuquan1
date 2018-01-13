//
//  XFVideoMoreCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVideoMoreCell.h"
#import "XFVideoModel.h"

@implementation XFVideoMoreSubCell

- (instancetype)initWithModel:(XFVideoModel *)model {

    if (self = [super init]) {
        
        _model = model;
        
        _picNode = [[XFNetworkImageNode alloc] init];
        _picNode.image = [UIImage imageNamed:@"zhanweitu22"];
        
        _picNode.url = [NSURL URLWithString:_model.video[@"coverUrl"]];
        
        [self addSubnode:_picNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:_model.title];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        _numberNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *numStr = [[NSMutableAttributedString  alloc] initWithString:[NSString stringWithFormat:@"播放%@次",_model.viewNum]];
        
        numStr.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:10],
                           NSForegroundColorAttributeName:UIColorHex(808080)
                           };
        
        _numberNode.attributedText = numStr;
        
        _numberNode.maximumNumberOfLines = 1;
        [self addSubnode:_numberNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _picNode.style.preferredSize = CGSizeMake(125, 75);
    
    _nameNode.style.spacingBefore = 10;
    _numberNode.style.spacingBefore = 5;
    
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_picNode,_nameNode,_numberNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 12, 0)) child:allLayout];
    
}

@end

@implementation XFVideoMoreCell

- (instancetype)initWithInfo:(NSDictionary *)info {
    
    if (self = [super init]) {
        
        _allinfo = info;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _iconNode = [[XFNetworkImageNode alloc] init];
        _iconNode.image = [UIImage imageNamed:@"zhanweitu44"];
        _iconNode.url = [NSURL URLWithString:_allinfo[@"user"][@"headIconUrl"]];
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:_allinfo[@"user"][@"nickname"] ? _allinfo[@"user"][@"nickname"] : @""];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        // 关注
        _followButton = [[ASButtonNode alloc] init];
        [_followButton setTitle:@"+ 关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_followButton setTitle:@"已关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _followButton.selected = [_allinfo[@"user"][@"followed"] boolValue];
        _followButton.backgroundColor = UIColorHex(F72F5E);
        [self addSubnode:_followButton];
        _followButton.cornerRadius = 4;
        _followButton.clipsToBounds = YES;
        
        [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        _moreNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *moreStr = [[NSMutableAttributedString  alloc] initWithString:@"更多视频"];
        
        moreStr.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _moreNode.attributedText = str;
        
        _moreNode.maximumNumberOfLines = 1;
        [self addSubnode:_moreNode];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake(125, 135);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        [self addSubnode:_collectionNode];
        
    }
    return self;
}

- (void)clickFollowButton:(ASButtonNode *)button {
    
    if (self.clickFollowButtonBlock) {
        self.clickFollowButtonBlock(button);
    }
    
}

- (void)setColl {
    
    self.collectionNode.view.showsHorizontalScrollIndicator = NO;
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    NSDictionary *dic = self.allinfo[@"videoSuggestion"];
    NSArray *arr = dic[@"content"];
    
    return arr.count;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode *() {
      
        NSDictionary *dic = self.allinfo[@"videoSuggestion"];
        NSArray *arr = dic[@"content"];
        
        XFVideoModel *model = [XFVideoModel modelWithDictionary:arr[indexPath.item]];
    
        XFVideoMoreSubCell *cell = [[XFVideoMoreSubCell alloc] initWithModel:model];
        
        return cell;
        
    };
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, 135);
    _iconNode.style.preferredSize = CGSizeMake(44, 44);
    _followButton.style.preferredSize = CGSizeMake(68, 29);
    
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode]];
    
    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
    
    // 上面一层
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];
    
    ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 0, 10)) child:upLayout];
    ASInsetLayoutSpec *moreInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 0, 10)) child:_moreNode];

    // label
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,moreInset,_collectionNode]];

    
    return allLayout;
    
}

@end
