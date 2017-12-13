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

 @param openAlbumId 开放相册Id
 @param intimateAlbumId 隐私相册Id
 @param opens 开放照片
 @param intimates 隐私照片
 @param type 类型
 @param title 内容
 @param unlockNum 解锁钻石数量
 @param customLabel 自定义标签
 @param labels 标签
 @param success 成功
 @param failedBlock 失败
 */
+ (void)publishStatusWithopenAlbumId:(NSString *)openAlbumId intimateAlbumId:(NSString *)intimateAlbumId opens:(NSArray *)opens intimates:(NSArray *)intimates type:(NSString *)type title:(NSString *)title unlockNum:(NSString *)unlockNum customLabel:(NSString *)customLabel labels:(NSString *)labels successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

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
+ (void)likeStatusWithStatusId:(NSString *)releaseId userNo:(NSString *)userNo successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock;

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
