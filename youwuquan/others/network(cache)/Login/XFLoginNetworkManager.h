//
//  XFLoginNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginRequestSuccessBlock)(id responseObj);
typedef void(^LoginRequestFailedBlock)(NSError *error);
typedef void(^LoginRequestProgressBlock)(CGFloat progress);

@interface XFLoginNetworkManager : NSObject


/**
 获取验证码

 @param phoneNumber 手机号码
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)getCodeWithPhoneNumber:(NSString *)phoneNumber progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 注册账号

 @param phoneNumber 手机号码
 @param pwd pwd
 @param code 验证码
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)registWithPhone:(NSString *)phoneNumber pwd:(NSString *)pwd code:(NSString *)code progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 修改密码

 @param pwd 新密码
 @param progressBlock  1
 @param successBlock 1
 @param failBlock   1
 */
+ (void)changePwdWithNewPwd:(NSString *)pwd progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 登录

 @param phone 账号
 @param pwd 密码
 @param longitude 精度
 @param latitude 纬度
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd longitude:(NSString *)longitude latitude:(NSString *)latitude progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 登出

 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)logoutWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 获取imToken

 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)getImTokenWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 注册完成之后保存信息

 @param nickName 昵称
 @param birthday 生日
 @param sex 性别
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)saveUserInfoWithnickName:(NSString *)nickName birthday:(NSString *)birthday sex:(NSString *)sex progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 获取所有标签

 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)getAllTagsWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

/**
 第三方绑定账号

 @param type 类型
 @param username 账户
 @param token token
 @param phone 手机
 @param code 验证码
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 */
+ (void)signUpWithType:(NSString *)type username:(NSString *)username token:(NSString *)token phone:(NSString *)phone code:(NSString *)code progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock;

+ (void)loginRongyunWithRongtoken:(NSString *)rongToken successBlock:(LoginRequestSuccessBlock)success failedBlock:(LoginRequestFailedBlock)failed;


/**
 查看是否注册过

 @param uid uid
 @param success 成功
 @param failed 失败
 */
+ (void)checkIsHasUserWith:(NSString *)uid
              successBlock:(LoginRequestSuccessBlock)success
               failedBlock:(LoginRequestFailedBlock)failed;


/**
 刷新/获取token

 @param success 0
 @param failed 0
 */
+ (void)getMyTokenWithsuccessBlock:(LoginRequestSuccessBlock)success
                       failedBlock:(LoginRequestFailedBlock)failed;


/**
 token登录

 @param token token
 @param success 0
 @param failed 0
 */
+ (void)loginWithToken:(NSString *)token
          successBlock:(LoginRequestSuccessBlock)success
           failedBlock:(LoginRequestFailedBlock)failed;

@end
