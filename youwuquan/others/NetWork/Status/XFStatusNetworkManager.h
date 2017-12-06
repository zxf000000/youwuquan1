//
//  XFStatusNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^RequestSuccessBlock)(NSDictionary *reponseDic);
typedef void(^RequestFailedBlock)(NSError *error);

@interface XFStatusNetworkManager : NSObject

/**
 获取我的动态

 @param start 开始数量
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getMyStatusWithStart:(NSString *)start successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 关注或者取关某人

 @param followUserNo 对方userNumber
 @param success 成功
 @param failedBlock 失败
 */
+ (void)followSomeoneWithUserNumber:(NSString *)followUserNo successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 我的发布

 @param albumId 相册Id
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getMyPublishWithalbumId:(NSString *)albumId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 我的相册

 @param success 成功
 @param failedBlock 失败
 */
+ (void)getMyAlbumWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 发布动态

 @param businType 类型
 @param openAlbumId 开放相册id
 @param intimateAlbumId 隐私相册id
 @param opens 开放图片
 @param intimates 隐私图片
 @param files 视频
 @param jsonString json
 @param labels 标签
 @param jsonVideo 视频json
 */
+ (void)publishStatusWithbusinType:(NSString *)businType openAlbumId:(NSString *)openAlbumId intimateAlbumId:(NSString *)intimateAlbumId opens:(NSString *)opens intimates:(NSString *)intimates files:(NSString *)files jsonString:(NSString *)jsonString  labels:(NSString *)labels jsonVideo:(NSString *)jsonVideo;

/**
 不需要登录查看的动态

 @param success 成功
 @param failedBlock 失败
 */
+ (void)getStatusWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 推荐动态

 @param start 开始
 @param success 成功
 @param failedBlock 失败
 */
+ (void)invitedStatusWithStart:(NSString *)start successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 关注的动态

 @param success 成功
 @param failedBlock 失败
 */
+ (void)careStatusWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取详情

 @param releaseId 动态Id
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getStatusDetailWithReleaseId:(NSString *)releaseId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取我的相册

 @param success 成功
 @param failedBlock 失败
 */
+ (void)getAlbumIdWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 点赞

 @param releaseId 点赞的动态
 @param success 成功
 @param failedBlock 失败
 */
+ (void)likeStatusWithStatusId:(NSString *)releaseId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 评论

 @param releaseId 动态id
 @param message 内容
 @param success 成功
 @param failedBlock 失败
 */
+ (void)commentStatusWithId:(NSString *)releaseId message:(NSString *)message successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取所有标签
 @param failedBlock 失败
 */
+ (void)getAllTagsWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

@end
