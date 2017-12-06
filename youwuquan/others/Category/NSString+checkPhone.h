//
//  NSString+checkPhone.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/20.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (checkPhone)
// 是否是手机号码
- (BOOL)isPhoneNumber;
// 是否含有内容
- (BOOL)isHasContent;
// 密码内容
-(BOOL)isPasswordContent;
// 昵称
- (BOOL) isNickName;
// 名字
- (BOOL)isName;
/**
 邮箱
 */
- (BOOL)isEmail;
/**
 微信号码
 */
- (BOOL)isWxNumbver;

/**
 身份整
 */
- (BOOL)isIdCard;

@end
