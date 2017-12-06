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


+ (UIImage *)creatQRcodeWithInfo:(NSString *)path;

@end
