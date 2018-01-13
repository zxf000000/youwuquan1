//
//  XFNetworking+RequestManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNetworking.h"

@interface XFNetworking (RequestManager)

/**
 判断网络请求池中是否有相同的请求

 @param task 网络请求任务
 @return pool
 */
+ (BOOL)haveSameRequestInTasksPool:(XFURLSEssionTask *)task;

/**
 如果有旧的请求则取消旧的请求

 @param task 新请求
 @return 旧请求
 */
+ (XFURLSEssionTask *)cancelSameRequestTasksPool:(XFURLSEssionTask *)task;

@end
