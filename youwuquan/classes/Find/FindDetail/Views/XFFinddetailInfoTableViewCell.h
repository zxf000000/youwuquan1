//
//  XFFinddetailInfoTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFFinddetailInfoTableViewCell : ASCellNode

@property (nonatomic,strong) ASTextNode *heightNode;
@property (nonatomic,strong) ASTextNode *heiNUmberNode;
@property (nonatomic,strong) ASTextNode *wightNode;
@property (nonatomic,strong) ASTextNode *wightNumberNode;
@property (nonatomic,strong) ASTextNode *swNode;
@property (nonatomic,strong) ASTextNode *swNumberNode;
@property (nonatomic,strong) ASTextNode *desNode;
@property (nonatomic,strong) ASTextNode *desDetailNode;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,copy) NSDictionary *userInfo;

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;

@end
