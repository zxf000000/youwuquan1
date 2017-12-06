//
//  XFShareManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFShareManager : NSObject

+ (UIImage *)sharedImageWithBg:(NSString *)bgImg icon:(NSString *)icon name:(NSString *)name userid:(NSString *)userid address:(NSString *)address;

+ (UIImage *)sharedUrl:(NSString *)urlStr;

@end
