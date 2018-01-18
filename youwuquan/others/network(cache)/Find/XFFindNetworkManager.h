//
//  XFFindNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/3.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FindRequestSuccessBlock)(id responseObj);
typedef void(^FindRequestFailedBlock)(NSError *error);
typedef void(^FindRequestProgressBlock)(CGFloat progress);


@interface XFFindNetworkManager : NSObject

/**
 获取发现页面广告

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getFindAdWithPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;
/**
 推荐数据

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getInviteDataWithPage:(NSInteger)page rows:(NSInteger)rows SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 获取关注数据

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getFollowsDataWithPage:(NSInteger)page rows:(NSInteger)rows SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 获取我的所有动态

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getAllMyStatusWithPage:(NSInteger )page rows:(NSInteger)rows successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 获取其他用户动态

 @param userId userId
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getOtherStatusListWithUserId:(NSString *)userId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;


/**
 发布

 @param type 类型(word,picture,video)
 @param title title
 @param unlockPrice 解锁金额
 @param labels 标签()逗号隔开
 @param text 文字
 @param srcTypes 图片类型(open,close)
 @param images 图片数组
 @param videoCoverUrl 视频封面
 @param videoUrl 视频url
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)publishWithType:(NSString *)type title:(NSString *)title unlockPrice:(long)unlockPrice labels:(NSString *)labels text:(NSString *)text srcTypes:(NSString *)srcTypes images:(NSArray *)images videoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 删除一条动态

 @param statusId 动态id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)deleteStatusWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 获取一条动态想抢

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getOneStatusWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 获取动态评论列表

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getStatusCommentListWithId:(NSString *)statusId page:(NSInteger)page size:(NSInteger)size successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 评论动态

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentStatusWithId:(NSString *)statusId text:(NSString *)text successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 删除评论

 @param statusId id
 @param commentId 评论id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)deleteCommentWithId:(NSString *)statusId commentId:(NSString *)commentId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 回复评论

 @param statusId 动态ID
 @param commentId 评论ID
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentCommentWithId:(NSString *)statusId commentId:(NSString *)commentId text:(NSString *)text successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 关注列表

 @param statusId 动态id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)likeListWithStatus:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 点赞

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)likeWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock;

/**
 取消点赞

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)unlikeWithStatusId:(NSString *)statusId
              successBlock:(FindRequestSuccessBlock)successBlock
                 failBlock:(FindRequestFailedBlock)failBlock
                  progress:(FindRequestProgressBlock)progressBlock;


/**
 获取点赞列表

 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getLikeLIstWithStatusId:(NSString *)statusId
                   successBlock:(FindRequestSuccessBlock)successBlock
                      failBlock:(FindRequestFailedBlock)failBlock
                       progress:(FindRequestProgressBlock)progressBlock;


/**
 解锁动态
 @param statusId 动态id
 */
+ (void)unlockStatusWithStatusId:(NSString *)statusId
                    successBlock:(FindRequestSuccessBlock)successBlock
                       failBlock:(FindRequestFailedBlock)failBlock
                        progress:(FindRequestProgressBlock)progressBlock;

/**
 获取用户微信

 @param uid uid
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getUserWechatWithUid:(NSString *)uid
                successBlock:(FindRequestSuccessBlock)successBlock
                   failBlock:(FindRequestFailedBlock)failBlock
                    progress:(FindRequestProgressBlock)progressBlock;

/**
 附近的人

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getNearbyDataWithSuccessBlock:(FindRequestSuccessBlock)successBlock
                            failBlock:(FindRequestFailedBlock)failBlock
                             progress:(FindRequestProgressBlock)progressBlock;


/**
 上传文件到七牛

 @param data 数据
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)uploadFileWithData:(NSData *)data
              successBlock:(FindRequestSuccessBlock)successBlock
                 failBlock:(FindRequestFailedBlock)failBlock
                  progress:(FindRequestProgressBlock)progressBlock;


/**
 获取礼物列表

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getGiftListWithSuccessBlock:(FindRequestSuccessBlock)successBlock
                          failBlock:(FindRequestFailedBlock)failBlock
                           progress:(FindRequestProgressBlock)progressBlock;

/**
 打赏

 @param uid uid
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)rewardSomeoneWithUid:(NSString *)uid
            rewardResourceId:(long)rewardResourceId
                      amount:(NSInteger)amount
                successBlock:(FindRequestSuccessBlock)successBlock
                   failBlock:(FindRequestFailedBlock)failBlock
                    progress:(FindRequestProgressBlock)progressBlock;

@end
