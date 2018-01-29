//
//  XFToolManager.h
//  shilitaohua
//
//  Created by mr.zhou on 2017/8/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XFHomeTableNode.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

typedef void(^completeBlock)(void);

@interface XFToolManager : NSObject 


/**
 状态栏操作

 @param hidden 是否隐藏
 */
+ (void)statusBarHidhen:(BOOL)hidden;
/**
 获取视频时长和大小

 @param path 路径
 @return 时长duration 大小size
 */
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path;
/**
 转换时间

 @param dateObj 返回时间对象
 @return 时间字符串
 */
+ (NSString *)changeLongToDateWith:(id)dateObj;

/**
 j加装个加载成一个

 @param view view
 @param text 内容
 @return HUD
 */
+ (MBProgressHUD *)showJiaHUDToView:(UIView *)view string:(NSString *)text;
/**
 模糊

 @param image 图片
 @param blur 程度
 @return 模糊图
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


/**
 模糊图片

 @param image 图片
 @return 模糊
 */
+ (UIImage *)filterImageWith:(UIImage *)image;

/**
 获取视频文件缩略图

 @param videoURL 视频url
 @return 缩略图
 */
+ (UIImage *)getImage:(NSString *)videoURL;
/**
 字典转字符串

 @param object 字典
 @return 字符串
 */
+ (NSString*)DataTOjsonString:(id)object;

+ (NSString *)timeStringWithTime:(Float64)time;

/**
 计算星座

 @param m 月份
 @param d 天
 @return 星座
 */
+ (NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d;

/**
 展示菊花

 @param view 展示的view
 @return 菊花
 */
+ (MBProgressHUD *)showProgressHUDtoView:(UIView *)view;

/**
 展示带文字的菊花

 @param view 添加的view
 @param text 文字
 @return HUD实例
 */
+ (MBProgressHUD *)showProgressHUDtoView:(UIView *)view withText:(NSString *)text;


/**
 更改菊花称为文字

 @param HUD 菊花
 @param text 文字
 */
+ (void)changeHUD:(MBProgressHUD *)HUD successWithText:(NSString *)text;

// 获取指定宽度字符串的高度
+ (CGFloat)getHeightFortext:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
// 菊花
+ (UIActivityIndicatorView *)showIndicatorViewTo:(UIView *)view;

// 点赞冬瓜
+ (void)popanimationForLikeNode:(CALayer *)layer complate:(completeBlock)completeHandle;
// 缩放图片
+ (UIImage *)changeImageToWidth:(CGFloat)width image:(UIImage *)image;

/**
 *  文字提示
 */
+ (void)showProgressInWindowWithString:(NSString *)string;
/**
 *  随机32位支付穿
 */
+ (NSString *)ret32bitString;
/**
 *  MD5加密
 */
+ (NSString *) md5:(NSString *) input;

/**
 *  sha1加密
 */
+ (NSString *) sha1:(NSString *)input;

/**
 *  手机号判定
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 压缩图片尺寸
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 *  计算label的行数
 */
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

+ (CGFloat)getWidthForString:(NSString *)text forFont:(UIFont *)font;

// 圆角
+ (void)setTopCornerwith:(CGFloat)cornerRadius view:(UIView *)view;

// 按钮倒计时
+ (void)countdownbutton:(UIButton *)countButton;


/**
 date更改为(分钟/天/年之前)

 @param date date
 @return string
 */
+ (NSString *)changeDateToStringWithDate:(NSDate *)date;

+ (MJRefreshGifHeader *)refreshHeaderWithBlock:(void(^)(void))block;

@end
