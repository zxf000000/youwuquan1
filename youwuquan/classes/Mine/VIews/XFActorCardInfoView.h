//
//  XFActorCardInfoView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XFInfoCardViewType) {
    
    InfoCardTypeVertical = 0,// 垂直
    InfoCardTypeStandard, // 水平
    InfoCardTypeCompact, // 垂直紧凑
    InfoCardTypeRectangle, // 紧凑平铺
    
};

@interface XFActorCardInfoView : UIView

@property (nonatomic,strong) UIView *nameView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *birthdayLabel;

@property (nonatomic,strong) UILabel *heightLabel;

@property (nonatomic,strong) UILabel *wightLabel;

@property (nonatomic,strong) UILabel *xwLabel;

@property (nonatomic,strong) UILabel *yyLabel;

@property (nonatomic,strong) UILabel *twLabel;

@property (nonatomic,strong) UIView *upLine;

@property (nonatomic,strong) UIView *downLine;

@property (nonatomic,assign) XFInfoCardViewType type;

- (instancetype)initWithFrame:(CGRect)frame type:(XFInfoCardViewType)type;

@end
