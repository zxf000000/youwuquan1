//
//  XFCreatShareImgManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCreatShareImgManager : NSObject

+ (UIImage *)shareImgWithBgImage:(UIImage *)bgImage iconImage:(UIImage *)iconImage name:(NSString *)name userId:(NSString *)userId address:(NSString *)address;

// 绘制分享注册页面
+ (UIImage *)shareurlImgWithBgImage:(UIImage *)bgImage iconImage:(UIImage *)iconImage url:(NSString *)url;

+ (UIImage *)creatQRcodeWithInfo:(NSString *)path;

@end
