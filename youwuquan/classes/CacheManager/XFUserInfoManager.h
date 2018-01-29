//
//  XFUserInfoManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/25.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache.h>

@interface XFUserInfoManager : NSObject

+ (instancetype)sharedManager;

// token存储时间
@property (nonatomic,strong) NSDate *tokenDate;

// 融云token
@property (nonatomic,copy) NSString *rongToken;
// 用户token
@property (nonatomic,copy) NSString *token;
// 用户账号
@property (nonatomic,copy) NSString *userName;
// 用户昵称
@property (nonatomic,copy) NSString *nickName;
// 生日
@property (nonatomic,copy) NSString *userBirthday;
// 性别
@property (nonatomic,copy) NSString *sex;
// 常住地
@property (nonatomic,copy) NSString *userAddress;
// 星座
@property (nonatomic,copy) NSString *xingzuo;
// 腰围
@property (nonatomic,copy) NSString *yaowei;
// 胸围
@property (nonatomic,copy) NSString *xiongwei;
// 臀围
@property (nonatomic,copy) NSString *tunwei;
// 身高
@property (nonatomic,copy) NSString *userHeight;
// 微信号码
@property (nonatomic,copy) NSString *wxNumber;
// 手机号码
@property (nonatomic,copy) NSString *phoneNumber;
// 个人简介
@property (nonatomic,copy) NSString *userDescript;
// 个人标签
@property (nonatomic,copy) NSString *userLabel;
// 密码
@property (nonatomic,copy) NSString *pwd;

// 经纬度
@property (nonatomic,assign) CGFloat userLong;
@property (nonatomic,assign) CGFloat userLati;

// 上次拉取消息的时间
@property (nonatomic,copy) NSString *lastGetNotificationDate;


@property (nonatomic,strong) YYCache *userCache;

@property (nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic,copy) NSString *cookie;

- (void)updateToken:(NSString *)token;

- (void)updateTokenDate:(NSDate *)tokenDate;

- (void)updateUserInfo:(id)userInfo;

- (void)updateCookieWith:(NSString *)cookie;

- (void)updateLastDate:(NSString *)lastData;

/**
 删除所有信息
 */
- (void)removeAllData;
@end
