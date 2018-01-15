//
//  XFFindNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/3.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFFindNetworkManager.h"
#import "XFNetworking.h"
#import "XFApiClient.h"

@implementation XFFindNetworkManager

/**
 获取发现页面广告
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getFindAdWithPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetFindAd] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

/**
 推荐数据
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getInviteDataWithPage:(NSInteger)page rows:(NSInteger)rows SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"page":@(page),
                             @"size":@(rows)
                             };
    
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetInviteStatus] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

// 获取点赞列表
+ (void)getLikeLIstWithStatusId:(NSString *)statusId
                   successBlock:(FindRequestSuccessBlock)successBlock
                      failBlock:(FindRequestFailedBlock)failBlock
                       progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForLikeWithStatus:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 获取关注数据
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getFollowsDataWithPage:(NSInteger)page rows:(NSInteger)rows SuccessBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForCareStatus] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(rows)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 获取我的所有动态
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getAllMyStatusWithPage:(NSInteger )page rows:(NSInteger)rows successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"page":@(page),
                             @"size":@(rows)
                             };
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetAllMyStatus] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 获取其他用户动态
 
 @param userId userId
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getOtherStatusListWithUserId:(NSString *)userId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetOtherStatusWith:userId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}


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
+ (void)publishWithType:(NSString *)type title:(NSString *)title unlockPrice:(long)unlockPrice labels:(NSString *)labels text:(NSString *)text srcTypes:(NSString *)srcTypes images:(NSArray *)images videoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:type forKey:@"type"];
    [params setObject:title forKey:@"title"];
    [params setObject:@(unlockPrice) forKey:@"unlockPrice"];
    [params setObject:text forKey:@"text"];
    if (labels) [params setObject:labels forKey:@"labels"];
    if ( images.count > 0 ) {
        
        [params setObject:srcTypes forKey:@"srcTypes"];
    
    } else if (videoUrl) {
        
        [params setObject:videoUrl forKey:@"videoUrl"];
        [params setObject:videoCoverUrl forKey:@"videoCoverUrl"];
        [params setObject:srcTypes forKey:@"srcTypes"];

        
    } else {

        
    }
    
    [XFNetworking publishStatusWithUrl:[XFApiClient pathUrlForPublishStatus] images:images type:@"image" name:@"images" mimeType:@"image/jpeg" params:params progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
        
        progressBlock(bytesWriten/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];

    
}

/**
 删除一条动态
 
 @param statusId 动态id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)deleteStatusWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForDeleteStatusWithStatusId:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 获取一条动态想抢
 
 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getOneStatusWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetStatusWithStatusId:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

/**
 获取动态评论列表
 
 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getStatusCommentListWithId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetStatusCommentListWith:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 评论动态
 
 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentStatusWithId:(NSString *)statusId text:(NSString *)text successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"text":text};
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForCommentStatusWithId:statusId] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 删除评论
 
 @param statusId id
 @param commentId 评论id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)deleteCommentWithId:(NSString *)statusId commentId:(NSString *)commentId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForDeleteCommentWithStatusId:statusId commentId:commentId] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 回复评论
 
 @param statusId 动态ID
 @param commentId 评论ID
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)commentCommentWithId:(NSString *)statusId commentId:(NSString *)commentId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForcommentCommentWithStatusId:statusId commentId:commentId] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 关注列表
 
 @param statusId 动态id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)likeListWithStatus:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForFollows] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 点赞
 
 @param statusId id
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)likeWithStatusId:(NSString *)statusId successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLikeWithStatus:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                  progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForUnlikeStatus:statusId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}


/**
 解锁动态
 @param statusId 动态id
 */
+ (void)unlockStatusWithStatusId:(NSString *)statusId
                    successBlock:(FindRequestSuccessBlock)successBlock
                       failBlock:(FindRequestFailedBlock)failBlock
                        progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForUnlockStatusWithId:statusId] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                    progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForUnlockWechat:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

/**
 附近的人
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getNearbyDataWithSuccessBlock:(FindRequestSuccessBlock)successBlock
                            failBlock:(FindRequestFailedBlock)failBlock
                             progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetNearby] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

+ (void)uploadFileWithData:(NSData *)data successBlock:(FindRequestSuccessBlock)successBlock failBlock:(FindRequestFailedBlock)failBlock progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking uploadFileWithUrl:[XFApiClient pathUrlForUploadToQiniu] fileData:data type:@"image" name:@"file" mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
        
        progressBlock(bytesWriten/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

/**
 获取礼物列表
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getGiftListWithSuccessBlock:(FindRequestSuccessBlock)successBlock
                          failBlock:(FindRequestFailedBlock)failBlock
                           progress:(FindRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetGiftList] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

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
                    progress:(FindRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"rewardResourceId":@(rewardResourceId),
                             @"amount":@(amount)
                             };
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForRewardWith:uid] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

@end
