//
//  XFNetWorkManager.h
//  shilitaohua
//
//  Created by mr.zhou on 2017/8/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

typedef void(^RequestSuccessBlock)(NSDictionary *responseDic);
typedef void(^RequestFailedBlock)(NSError *error);


@interface XFNetWorkManager : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

+ (instancetype)sharedManager;


/**
 带token的请求

 @param urlString 请求url
 @param paraments 参数
 @param successBlock 成功
 @param failedBlock 失败
 */
- (void)postWithTokenWithUrl:(NSString *)urlString paraments:(NSMutableDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;


/**
 *  普通post请求
 *
 *  @param urlString    请求url
 *  @param paraments    参数
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 */
- (void)postUrl:(NSString *)urlString paraments:(NSMutableDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;
/**
 *  上传图片
 *
 *  @param data         图片数据
 *  @param url          请求地址
 *  @param paraments    参数
 *  @param successBlock 成功
 *  @param failedBlock  失败
 */
- (void)uploadData:(NSData *)data url:(NSString *)url name:(NSString *)name paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

- (void)noneStatuspostUrl:(NSString *)urlString paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

@end
