//
//  XFMyHeaderNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFMyHeadercellnode : ASCellNode

@property (nonatomic,strong) ASImageNode *iconNode;
@property (nonatomic,strong) ASTextNode *titleNode;

@end

@protocol XFMyHeaderDelegate <NSObject>

- (void)headerDidSelectItemAtIndex:(NSInteger)index;

- (void)headerDidClickInvitebutton;

- (void)headerDidClickCarelabel;
- (void)headerDidClickfanslabel;
- (void)headerDidClickStatuslabel;

@end

@interface XFMyHeaderNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASButtonNode *fansButton;
@property (nonatomic,strong) ASButtonNode *caresButton;
@property (nonatomic,strong) ASButtonNode *statusNode;

@property (nonatomic,strong) ASTextNode *fansLabel;
@property (nonatomic,strong) ASTextNode *fansNumberLabel;

@property (nonatomic,strong) ASTextNode *careLabel;
@property (nonatomic,strong) ASTextNode *careNumberLabel;

@property (nonatomic,strong) ASTextNode *statusLabel;
@property (nonatomic,strong) ASTextNode *statusNumberLabel;

@property (nonatomic,strong) ASButtonNode *inviteButton;

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,strong) ASDisplayNode *topBgNode;

@property (nonatomic,strong) ASDisplayNode *BgNode;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) NSArray *imgs;

@property (nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic,strong) id <XFMyHeaderDelegate> delegate;

- (instancetype)initWithUserinfo:(NSDictionary *)userInfo;
@end
