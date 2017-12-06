//
//  XFFindApproveNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

typedef NS_ENUM(NSInteger,CellType) {
    
    Approve,
    Skill,
    
};
// 技能
@interface XFFindSkillCellNode : ASCellNode

@property (nonatomic,strong) ASButtonNode *button;

@end
// 认证
@interface XFFindCollectionCellNode : ASCellNode

@property (nonatomic,strong) ASButtonNode *button;

@end

@interface XFFindApproveNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASCollectionNode *collectionNpde;

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) NSArray *titleImgs;

@property (nonatomic,assign) CellType type;

@property (nonatomic,copy) NSArray *skillImgs;

- (instancetype)initWithType:(CellType)type;


@end
