//
//  NSUserDefaults+saveUserInfo.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/25.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (saveUserInfo)

// 存储用户信息
+ (void)saveUserInfoWithDic:(NSDictionary *)info ;
// 获取用户信息
+ (NSDictionary *)getUserInfo;
// 更改本地的用户信息
+ (NSDictionary *)changeUserInfoWithKey:(NSString *)key value:(NSString *)value;
// 存储userId
+ (void)saveUserIdWith:(NSString *)userId;
// 存储UserName和password
+ (void)saveUserNameWith:(NSString *)userName password:(NSString *)password;
// 获取当前存储的userName
+ (NSString *)getCurrentUserName;
// 获取userName的password
+ (NSString *)getPassWordForUserName:(NSString *)userName;
// 删除所有用户信息
+ (void)deleteAllUserInfo;

@end
