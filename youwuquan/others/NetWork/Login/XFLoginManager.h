//
//  XFLoginManager.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/18.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFNetWorkApiTool.h"
#import "XFNetWorkManager.h"

typedef void(^LoginSuccessBlock)(id reponseDic);
typedef void(^LoginFailedBlock)(NSError *error);

@interface XFLoginManager : NSObject
// 单例
+ (instancetype)sharedInstance;


@property (nonatomic,strong) XFNetWorkManager *networkManager;



/**
 融云登录

 @param rongToken 融云token
 @param success 成功
 @param failed 失败
 */
- (void)loginRongyunWithRongtoken:(NSString *)rongToken successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 保存用户头像

 @param files 头像文件
 @param success 陈宫
 @param failed 失败
 */
- (void)saveUserIconWithfiles:(UIImage *)files successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;
/**
 登出

 @param success 陈宫
 @param failed 失败
 */
- (void)logoutWithsuccessBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 获取用户信息

 @param success 成
 @param failed 失败
 */
- (void)getUserInfoWithsuccessBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 Token登录

 @param token token
 @param success 成功
 @param failed 时报
 */
- (void)loginWithuserNumber:(NSString *)userNumber token:(NSString *)token successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 获取验证码

 @param phone 手机号
 @param success 成功
 @param failed 失败
 */
- (void)getCodeWithPhone:(NSString *)phone regist:(NSString *)regist successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 注册

 @param phone 电话
 @param pwd 密码
 @param codeNum 验证码
 @param platform 设备
 @param regist 类型
 @param success 成功
 @param failed 失败
 */
- (void)registWithPhone:(NSString *)phone pwd:(NSString *)pwd codeNum:(NSString *)codeNum platform:(NSString *)platform regist:(NSString *)regist successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

/**
 更改密码

 @param phone 手机
 @param pwd 密码
 @param code 验证码
 @param success 成功
 @param failed 失败
 */
- (void)changePwdWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;


/**
 保存用户信息

 @param userName 用户名
 @param nickname 用户昵称
 @param birthday 生日
 @param sex 性别
 @param tags 标签
 @param roleNos 角色
 @param headUrl 头像
 @param height 身高
 @param weight 体重
 @param bwh 三围
 @param weixin 微信
 @param synopsis 不知道
 @param success 成功
 @param failed 失败
 */
- (void)saveUserInfoWithUserName:(NSString *)userName nickName:(NSString *)nickname birthday:(NSString *)birthday sex:(NSString *)sex tags:(NSString *)tags roleNos:(NSString *)roleNos headUrl:(NSString *)headUrl height:(NSString *)height weight:(NSString *)weight bwh:(NSString *)bwh weixin:(NSString *)weixin synopsis:(NSString *)synopsis  successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;


/**
 注册成功保存用户信息

 @param userName 用户名
 @param nickname 昵称
 @param birthday 生日
 @param sex 性别
 @param tags 标签
 @param success 成功
 @param failed 失败
 */
- (void)registSaveUserInfoWithUserName:(NSString *)userName nickName:(NSString *)nickname birthday:(NSString *)birthday sex:(NSString *)sex tags:(NSString *)tags  successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;



/**
 登录

 @param userNumber 用户账号
 @param pwd 用户密码
 @param success 成功
 @param failed 失败
 */
- (void)loginWithUserNumber:(NSString *)userNumber pwd:(NSString *)pwd successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed;

@end
