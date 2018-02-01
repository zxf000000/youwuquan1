//
//  XFHomeNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/3.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^HomeRequestSuccessBlock)(id responseObj);
typedef void(^HomeRequestFailedBlock)(NSError *error);
typedef void(^HomeRequestProgressBlock)(CGFloat progress);


@interface XFHomeNetworkManager : NSObject

/**
 获取首页数据

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getHomeDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;

/**
 获取首页广告

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getHomeAdWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;

/**
 网红

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getHotDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;


/**
 更多网红

 @param page 0
 @param size 0
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getHotMoreDataWithPage:(NSInteger)page size:(NSInteger)size successBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;


/**
 尤物数据

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getYouwuDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;

/**
 获取更多尤物

 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)getYouwuMoreDataWithPage:(NSInteger)page size:(NSInteger)size successBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;


/**
 视频页面广告

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getVideoAdWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;

/**
 获取视频数据

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getVideoWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock;

/**
 视频详情

 @param videoId 视频id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getVideoDetailWithID:(NSString *)videoId
                successBlock:(HomeRequestSuccessBlock)successBlock
                   failBlock:(HomeRequestFailedBlock)failBlock
                    progress:(HomeRequestProgressBlock)progressBlock;

/**
 视频评论列表

 @param videoId videoId
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getVideoCommentListWithID:(NSString *)videoId
                     successBlock:(HomeRequestSuccessBlock)successBlock
                        failBlock:(HomeRequestFailedBlock)failBlock
                         progress:(HomeRequestProgressBlock)progressBlock;

/**
 评论视频

 @param videoId cideoId
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentVideWithVideoId:(NSString *)videoId
                          text:(NSString *)text
                  successBlock:(HomeRequestSuccessBlock)successBlock
                     failBlock:(HomeRequestFailedBlock)failBlock
                      progress:(HomeRequestProgressBlock)progressBlock;

/**
 删除评论

 @param videoId videoId
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)deleteCommentWithVideoId:(NSString *)videoId
                       commentId:(NSString *)commentID
                    successBlock:(HomeRequestSuccessBlock)successBlock
                       failBlock:(HomeRequestFailedBlock)failBlock
                        progress:(HomeRequestProgressBlock)progressBlock;
/**
 回复视频评论

 @param videoId videoId
 @param commentId 评论id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentCommentWithVideoId:(NSString *)videoId
                        commentId:(NSString *)commentId
                             text:(NSString *)text
                     successBlock:(HomeRequestSuccessBlock)successBlock
                        failBlock:(HomeRequestFailedBlock)failBlock
                         progress:(HomeRequestProgressBlock)progressBlock;

/**
 更新用户信息

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)refreshUserLocationWithlon:(double)longitude
                               lat:(double)lat
                      successBlock:(HomeRequestSuccessBlock)successBlock
                         failBlock:(HomeRequestFailedBlock)failBlock
                          progress:(HomeRequestProgressBlock)progressBlock;


/**
 获取附近的人

 @param gender 性别
 @param longitude 精度
 @param latitude 未读
 @param distance 距离
 @param page 页
 @param size 行
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getNearbyDataWithSex:(NSString *)gender
                   longitude:(double)longitude
                    latitude:(double)latitude
                    distance:(long)distance
                        page:(NSInteger)page
                        size:(NSInteger)size
                successBlock:(HomeRequestSuccessBlock)successBlock
                   failBlock:(HomeRequestFailedBlock)failBlock
                    progress:(HomeRequestProgressBlock)progressBlock;


/**
 点赞某人

 @param uid uid
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)likeSomeoneWithUid:(NSString *)uid
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock;

/**
 取消点赞某人
 
 @param uid uid
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)unlikeSomeoneWithUid:(NSString *)uid
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock;

/**
 高清视频列表

 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)getHDVideoWithPage:(NSInteger)page
                      size:(NSInteger)size
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock;

/**
 vr视频列表

 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)getVRVideoWithPage:(NSInteger)page
                      size:(NSInteger)size
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock;


/**
主页衡多数据
 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)getMoreHomeDataWithPage:(NSInteger)page
                      size:(NSInteger)size
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock;



/**
 解锁视频

 @param videoId vid
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)unlockVideoWithId:(NSString *)videoId
             successBlock:(HomeRequestSuccessBlock)successBlock
                failBlock:(HomeRequestFailedBlock)failBlock
                 progress:(HomeRequestProgressBlock)progressBlock;


/**
 获取搜索关键词

 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getSearchKeyWorkWithsuccessBlock:(HomeRequestSuccessBlock)successBlock
                               failBlock:(HomeRequestFailedBlock)failBlock
                                progress:(HomeRequestProgressBlock)progressBlock;



/**
 搜索用户

 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)searchUsersWithword:(NSString *)word
                       Page:(NSInteger)page
                       size:(NSInteger)size
               successBlock:(HomeRequestSuccessBlock)successBlock
                  failBlock:(HomeRequestFailedBlock)failBlock
                   progress:(HomeRequestProgressBlock)progressBlock;

/**
 搜索动态
 
 @param page 0
 @param size 0
 @param successBlock 0
 @param failBlock 0
 @param progressBlock 0
 */
+ (void)searchPublishsWithword:(NSString *)word
                       Page:(NSInteger)page
                       size:(NSInteger)size
               successBlock:(HomeRequestSuccessBlock)successBlock
                  failBlock:(HomeRequestFailedBlock)failBlock
                   progress:(HomeRequestProgressBlock)progressBlock;


@end
