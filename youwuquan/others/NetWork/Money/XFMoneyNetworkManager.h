//
//  XFMoneyNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccessBlock)(NSDictionary *responseDic);
typedef void(^RequestFailedBlock)(NSError *error);

@interface XFMoneyNetworkManager : NSObject

/**
 充值

 @param num 数量
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)chargeDiamondWithNUm:(NSString *)num successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 打赏

 @param userNo 接受人userNo
 @param num 数量
 @param sms 短信验证码
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)rewardWithUserNum:(NSString *)userNo num:(NSString *)num sms:(NSString *)sms successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 解锁动态

 @param releaseId 动态Id
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)ubLockStatusWithReleaseid:(NSString *)releaseId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

@end
