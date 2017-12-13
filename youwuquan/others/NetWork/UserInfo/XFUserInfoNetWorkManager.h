//
//  XFUserInfoNetWorkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^RequestSuccessBlock)(NSDictionary *responseDic);
typedef void(^RequestFailedBlock)(NSError *error);
@interface XFUserInfoNetWorkManager : NSObject


/**
 获取我的动态

 @param start 开始下表
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)getAllMyStatusWithStart:(NSInteger)start successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;
/**
 获取相册图片

 @param albumId 相册Id
 @param successBlock chenggong
 @param failedBlock shibai
 */
+ (void)getPhotoAlbumPicsWithId:(NSString *)albumId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;
/**
 上传照片到照片墙

 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)uploadImgTowallWithImages:(NSArray *)imgs SuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取所有技能

 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)getAllSkillsWithSuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取用户技能认证列表

 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)getUserSkillsWithSuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;


/**
 点亮或者编辑技能

 @param skillNo 技能变好
 @param inviteTime 时间
 @param invitePlace 地点
 @param inviteMoney 金额
 @param inviteDemand 备注
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)changeOrlightSkillWithSkillno:(NSString *)skillNo inviteTime:(NSString *)inviteTime invitePlace:(NSString *)invitePlace inviteMoney:(NSString *)inviteMoney inviteDemand:(NSString *)inviteDemand successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 获取账户信心
 */
+ (void)getMyMoneyInfoWithsuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

@end
