//
//  XFMessageNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/29.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFMessageNetworkManager.h"

@implementation XFMessageNetworkManager

/**
 根据时间获取系统通知列表
 
 @param dateStr 时间
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getSystemNotificationWithDate:(NSString *)dateStr
                         successBlock:(MsgRequestSuccessBlock)successBlock
                            failBlock:(MsgRequestFailedBlock)failedBlock
                        progressBlock:(MsgRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetSystemNotification] refreshRequest:YES cache:NO praams:@{@"date":dateStr} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
       
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        successBlock(response);
    } failBlock:^(NSError *error) {
        failedBlock(error);
    }];
    
}

/**
 根据时间获取个人通知列表
 
 @param dateStr 时间
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getPersonalNotificationWithDate:(NSString *)dateStr
                                   type:(NSString *)type
                           successBlock:(MsgRequestSuccessBlock)successBlock
                              failBlock:(MsgRequestFailedBlock)failedBlock
                          progressBlock:(MsgRequestProgressBlock)progressBlock {

    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetPersonNotification] refreshRequest:YES cache:NO praams:@{@"date":dateStr,@"types":type} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        successBlock(response);
    } failBlock:^(NSError *error) {
        failedBlock(error);
    }];
    
    
}

@end
