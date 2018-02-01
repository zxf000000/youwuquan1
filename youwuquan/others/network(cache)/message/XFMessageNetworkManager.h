//
//  XFMessageNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/29.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFApiClient.h"
#import "XFNetworking.h"

typedef void(^MsgRequestSuccessBlock)(id responseObj);
typedef void(^MsgRequestFailedBlock)(NSError *error);
typedef void(^MsgRequestProgressBlock)(CGFloat progress);


@interface XFMessageNetworkManager : NSObject


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
                        progressBlock:(MsgRequestProgressBlock)progressBlock;


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
                        progressBlock:(MsgRequestProgressBlock)progressBlock;

/**
 根据列表获取系统通知列表
 
 @param dateStr 时间
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getSystemNotificationListWithPage:(NSInteger)page
                                 size:(NSInteger)size
                         successBlock:(MsgRequestSuccessBlock)successBlock
                            failBlock:(MsgRequestFailedBlock)failedBlock
                        progressBlock:(MsgRequestProgressBlock)progressBlock;

@end
