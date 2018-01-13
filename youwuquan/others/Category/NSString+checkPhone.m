//
//  NSString+checkPhone.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/20.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "NSString+checkPhone.h"

@implementation NSString (checkPhone)

// 名字
- (BOOL)isName {
    
    NSString *passWordRegex = @"^([a-zA-Z0-9\u4e00-\u9fa5\\·]{1,10})$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
}

/**
 邮箱
 */
- (BOOL)isEmail {
    
    NSString *passWordRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
    
}

/**
 微信号码
 */
- (BOOL)isWxNumbver {
    

    NSString *passWordRegex = @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
    
}

/**
 身份整
 */
- (BOOL)isIdCard {
    
//    NSString *passWordRegex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$";
//    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
//    if ([pred evaluateWithObject:self]) {
//            return YES ;
//        }else
//            return NO;
    
    return YES;
    
}


- (BOOL)isHasContent {

    if (self != nil && self.length > 0) {
    
        return YES;
    } else {
    
        return NO;
    
    }
}

- (BOOL) isNickName
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5][a-zA-Z][a-zA-z0-9_]{4,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:self];
}


- (BOOL)isPhoneNumber {
    
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //   NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(BOOL)isPasswordContent{
    
   NSString *passWordRegex = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,18}$";
   NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
}

@end
