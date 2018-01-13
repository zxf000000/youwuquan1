//
//  XFFindApproveNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindApproveNode.h"
#import "XFMyAuthViewController.h"

#define kUnSelectedColor  UIColorHex(717171)

@implementation XFFindSkillCellNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _button = [[ASButtonNode alloc] init];
        _button.clipsToBounds = YES;
        
        [self addSubnode:_button];

    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _button.style.preferredSize = CGSizeMake(75, 75);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_button];
    
}
@end

@implementation XFFindCollectionCellNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _button = [[ASButtonNode alloc] init];
        _button.backgroundColor = kMainRedColor;
        _button.cornerRadius = 4;
        
        [self addSubnode:_button];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _button.style.preferredSize = CGSizeMake(100, 30);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_button];
    
}
@end

@implementation XFFindApproveNode

- (instancetype)initWithType:(CellType)type auths:(NSArray *)auths{
    
    if (self = [super init]) {
        
        _type = type;
        _auths = auths;
        
        NSMutableArray *authIDs = [NSMutableArray array];
        for (NSDictionary *dic in _auths) {
            
            [authIDs addObject:[NSString stringWithFormat:@"%@",dic[@"identificationId"]]];
            
        }
        
        self.authIds = authIDs.copy;
        
        self.backgroundColor = kBgGrayColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.shadowColor = UIColorHex(808080).CGColor;
        _bgNode.shadowOffset = CGSizeMake(0, 0);
        _bgNode.shadowOpacity = 0.5;
        _bgNode.backgroundColor = [UIColor whiteColor];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        if (_type == Approve) {
            
            CGFloat itemWidth = 100;
            layout.sectionInset = UIEdgeInsetsMake(15, (kScreenWidth - 300)/4, 22, (kScreenWidth - 300)/4);
            layout.minimumLineSpacing = 8;
            layout.minimumInteritemSpacing = (kScreenWidth - 300)/4;
            layout.itemSize = CGSizeMake(itemWidth, 30);
        } else {
            
            CGFloat itemWidth = 75;
            layout.sectionInset = UIEdgeInsetsMake(15, (kScreenWidth - 300)/5, 22, (kScreenWidth - 300)/5);
            layout.minimumLineSpacing = (kScreenWidth - 300)/5;
            layout.minimumInteritemSpacing = (kScreenWidth - 300)/5;
            layout.itemSize = CGSizeMake(itemWidth, itemWidth);
            
        }
        
        _collectionNpde = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        
        _collectionNpde.delegate = self;
        _collectionNpde.dataSource = self;
        
        _titleNode = [[ASTextNode alloc] init];
        
        [_titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:@"认证" lineSpace:2 kern:0];
        
        [self addSubnode:_bgNode];
        [self addSubnode:_collectionNpde];
        [self addSubnode:_titleNode];
        
        
    }
    return self;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    if (self.type == Approve) {
        
        return [XFAuthManager sharedManager].authList.count;

    } else {
        
        return self.skillImgs.count;
    }
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == Approve) {
        
        return ^ASCellNode*() {
            
            XFMyAuthModel *model = [XFAuthManager sharedManager].authList[indexPath.item];
        
            XFFindCollectionCellNode *node = [[XFFindCollectionCellNode alloc] init];
            
            [node.button setTitle:model.identificationName withFont:[UIFont systemFontOfSize:12] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//            [node.button setImage:[UIImage imageNamed:self.titleImgs[indexPath.item]] forState:(UIControlStateNormal)];
            [node.button setBackgroundImage:[UIImage imageNamed:@"find_rzred"] forState:(UIControlStateNormal)];
            
            if (![self.authIds containsObject:model.id])  {
                
                node.button.backgroundColor = UIColorHex(717171);
                [node.button setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];

            } else {
                
                [node.button setBackgroundImage:[UIImage imageNamed:@"find_rzred"] forState:(UIControlStateNormal)];

            }
            
            return node;
        };
        
    } else {
        
        return ^ASCellNode*() {
            
            XFFindSkillCellNode *node = [[XFFindSkillCellNode alloc] init];
            
            [node.button setImage:[UIImage imageNamed:self.skillImgs[indexPath.item]] forState:(UIControlStateNormal)];
            [node.button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2",self.skillImgs[indexPath.item]]] forState:(UIControlStateSelected)];

            if (indexPath.item > 4) {
                
                node.button.selected = YES;
            }
            
            return node;
        };
        
        
    }
    
    

    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec *titleInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 13, 0, 0)) child:_titleNode];
    CGFloat collectionheight = 30 * 4 + 15 + 22 + 8*3;

    if (self.type == Approve) {
        
    } else {
        collectionheight = 75*2 + 15 + 22 + (kScreenWidth - 300)/5;

    }
    
    
    _collectionNpde.style.preferredSize = CGSizeMake(kScreenWidth, collectionheight);
    
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[titleInset,_collectionNpde]];
    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:allLayout background:_bgNode];
    
    ASInsetLayoutSpec *bgInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
    
    return bgInset;
    
}

- (NSArray *)titles {
    
    if (_titles == nil) {
        
        _titles = @[@"尤物女神",@"网      红",@"演      员",@"精舞达人",@"嗨歌达人",@"美妆达人",@"美食达人",@"旅游达人",@"运动达人",@"摄影达人",@"穿搭达人"];
        
    }
    return _titles;
}

- (NSArray *)titleImgs {
    
    if (_titleImgs == nil) {
        
        _titleImgs = @[@"detail_V",@"detail_R",@"detail_S",@"detail_D",@"detail_H",@"detail_M",@"detail_F",@"detail_T",@"detail_A",@"detail_P",@"detail_C"];
    }
    return _titleImgs;
}

- (NSArray *)skillImgs {
    
    if (_skillImgs == nil) {
        
        _skillImgs = @[@"find_food",@"find_sing",@"find_drink",@"find_watch",@"find_game",@"find_party",@"find_teatime",@"find_photo"];
    }
    return _skillImgs;
}


@end
