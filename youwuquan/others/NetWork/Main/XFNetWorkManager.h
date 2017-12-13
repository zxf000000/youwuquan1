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
 上传到照片墙

 @param url url
 @param imgs 图片
 @param name 名称
 @param paraments 参数
 @param successBlock 成功
 @param failedBlock 失败
 */
- (void)publishUploadWithUrl:(NSString *)url imgs:(NSArray *)imgs name:(NSString *)name paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

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


/**
 发布数据

 @param url 地址
 @param opens 公开图片
 @param secs 隐私图片
 @param paraments 参数
 @param successBlock 成功
 @param failedBlock 失败
 */
- (void)publishUploadWithUrl:(NSString *)url Opens:(NSArray *)opens secs:(NSArray *)secs paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;



- (void)noneStatuspostUrl:(NSString *)urlString paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

@end
