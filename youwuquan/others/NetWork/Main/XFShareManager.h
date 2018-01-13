//
//  XFShareManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

@interface XFShareManager : NSObject <UMSocialShareMenuViewDelegate>

+ (UIImage *)sharedImageWithBg:(NSString *)bgImg icon:(UIImage *)icon name:(NSString *)name userid:(NSString *)userid address:(NSString *)address;

+ (UIImage *)sharedUrlImageWithBg:(NSString *)bgImg icon:(id)icon url:(NSString *)url;

+ (UIImage *)sharedUrl:(NSString *)urlStr image:(UIImage *)pic title:(NSString *)title detail:(NSString *)detail;

+ (void)shareImageWith:(UIImage *)image;

@end
