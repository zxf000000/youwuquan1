//
//  NSUserDefaults+saveUserInfo.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/25.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "NSUserDefaults+saveUserInfo.h"
//#import <SAMKeychain.h>
//
//
@implementation NSUserDefaults (saveUserInfo)
//
//
//+ (void)saveUserInfoWithDic:(NSDictionary *)info {
//
//    [[NSUserDefaults standardUserDefaults] setObject:info forKey:kUserInfoKey];
//
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSDictionary *)getUserInfo {
//
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey];
//
//}
//
//+ (NSDictionary *)changeUserInfoWithKey:(NSString *)key value:(NSString *)value {
//
//    NSDictionary *userInfo = [self getUserInfo];
//
//    NSMutableDictionary *mutUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
//
//    [mutUserInfo setObject:value forKey:key];
//
//    [self saveUserInfoWithDic:mutUserInfo];
//
//    return mutUserInfo;
//}
//
//+ (void)saveUserIdWith:(NSString *)userId {
//
//    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
//
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
//
//+ (void)saveUserNameWith:(NSString *)userName password:(NSString *)password {
//
//    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameKey];
//
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    [SAMKeychain setPassword:password forService:@"huishang" account:userName];
//
//}
//
//+ (NSString *)getCurrentUserName {
//
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
//
//}
//
//+ (NSString *)getPassWordForUserName:(NSString *)userName {
//
//    return [SAMKeychain passwordForService:@"huishang" account:userName];
//
//}
//
//+ (void)deleteAllUserInfo {
//
//    // 删除密码
//    [SAMKeychain deletePasswordForService:@"huishang" account:[self getCurrentUserName]];
//
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserIdKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//
//}

@end
