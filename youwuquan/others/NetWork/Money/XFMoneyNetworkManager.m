//
//  XFMoneyNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMoneyNetworkManager.h"
#import "XFNetWorkApiTool.h"
#import "XFNetWorkManager.h"

@implementation XFMoneyNetworkManager
/**
 充值
 
 @param num 数量
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)chargeDiamondWithNUm:(NSString *)num successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:num forKey:@"num"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForCharge] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
}

/**
 打赏
 
 @param userNo 接受人userNo
 @param num 数量
 @param sms 短信验证码
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)rewardWithUserNum:(NSString *)userNo num:(NSString *)num sms:(NSString *)sms successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:userNo forKey:@"userNo"];
    [para setObject:num forKey:@"num"];
    [para setObject:sms forKey:@"sms"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForReward] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
}

/**
 解锁动态
 
 @param releaseId 动态Id
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)ubLockStatusWithReleaseid:(NSString *)releaseId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:releaseId forKey:@"releaseId"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForUnlockStatus] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
}

@end
