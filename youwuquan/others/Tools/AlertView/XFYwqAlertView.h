//
//  XFYwqAlertView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGiftViewWidth (kScreenWidth - 20)
#define kGiftViewHeight 44/35.f * kGiftViewWidth

typedef void(^animationCompleteBlock)(void);

@interface XFYwqAlertView : UIView



- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail;

// 产痛提示框
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *doneButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *upLine;

@property (nonatomic,strong) UIView *downLine;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *detail;

@property (nonatomic,strong) UIView *buttonLine;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) void (^doneBlock)(void);
@property (nonatomic,copy) void (^cancelBlock)(void);

// 钻石
@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UITextField *numberTextField;
@property (nonatomic,strong) UIButton *rewardButton;
@property (nonatomic,strong) UILabel *remainNum;

// 送礼物
@property (nonatomic,strong) UIButton *giftButton;
@property (nonatomic,strong) UIView *slideView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *giftCollectionView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *minusButton;
@property (nonatomic,strong) UILabel *numberLabel;


// 传统
+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)title detail:(NSString *)detail;
// 只有确认按钮
+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)title detail:(NSString *)detail doneButtonTitle:(NSString *)done;
// 礼物
+ (instancetype)showGiftViewToView:(UIView *)view withGifts:(NSArray *)gifts prices:(NSArray *)prices diamondsLeft:(NSString *)left realGifts:(NSArray *)realGifts realPrices:(NSArray *)realPrices name:(NSString *)name icon:(NSString *)icon;

/**
 显示打赏成功

 @return nil
 */
+ (instancetype)showDiamond;

/**
 打赏

 @param view 添加的view
 @param detail 说明
 @param icon 头像
 @param remain 剩余多少
 @return nil
 */
+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)detail icon:(NSString *)icon remainNUmber:(NSString *)remain;

/**
 查看电话微信

 @param view 添加的View
 @param detail 说明
 @param icon 头像
 @param remain 需要多少
 @return nil
 */
+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)detail icon:(NSString *)icon needNUmber:(NSString *)remain;


- (void)showAnimation;

- (void)dsShowanimation;

- (void)diaShowanimation;

@end
