//
//  XFHomeNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/3.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFHomeNetworkManager.h"
#import "XFNetworking.h"
#import "XFApiClient.h"

@implementation XFHomeNetworkManager

+ (void)getHomeDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"longitude":@([XFUserInfoManager sharedManager].userLong),
                             @"latitude":@([XFUserInfoManager sharedManager].userLati),
                             @"distance":@(100),
                             @"gender":@""
                             };
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForHomePage] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
       
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getHomeAdWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForHomeAd] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getHotDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForNethot] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

+ (void)getHotMoreDataWithPage:(NSInteger)page size:(NSInteger)size successBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForMoreNethot] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getYouwuDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForPrettyGirl] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getYouwuMoreDataWithPage:(NSInteger)page size:(NSInteger)size successBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetMorePretty] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

+ (void)getVideoWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForVideoPage] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

+ (void)getVideoAdWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForVideoPageAd] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                    progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetVideoDetailWithId:videoId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                         progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetVideoCommentsWithId:videoId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                      progress:(HomeRequestProgressBlock)progressBlock {
    
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForCommentVideo:videoId] refreshRequest:NO cache:NO praams:@{@"text":text} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                        progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForDeleteCommentForVideo:videoId comment:commentID] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

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
                         progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForDeleteCommentForVideo:videoId comment:commentId] refreshRequest:YES cache:NO praams:@{@"text":text} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                          progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking putWithUrl:[XFApiClient pathUrlForRefreshLocation] refreshRequest:YES cache:NO praams:@{@"longitude":@(longitude),@"latitude":@(lat)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];

}

+ (void)getNearbyDataWithSex:(NSString *)gender
                   longitude:(double)longitude
                    latitude:(double)latitude
                    distance:(long)distance
                        page:(NSInteger)page
                        size:(NSInteger)size
                successBlock:(HomeRequestSuccessBlock)successBlock
                   failBlock:(HomeRequestFailedBlock)failBlock
                    progress:(HomeRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"gender":gender,
                             @"longitude":@(longitude),
                             @"latitude":@(latitude),
                             @"distance":@(distance),
                             @"page":@(page),
                             @"size":@(size)
                             };
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetNearby] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"%@",error.description);
        
        failBlock(error);
        
    }];
    
}

+ (void)likeSomeoneWithUid:(NSString *)uid
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLikeOther:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
    
    
}

+ (void)unlikeSomeoneWithUid:(NSString *)uid
              successBlock:(HomeRequestSuccessBlock)successBlock
                 failBlock:(HomeRequestFailedBlock)failBlock
                  progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForUnLikeOther:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];

}

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
                  progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetHdVideoList] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

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
                  progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetVrVideoList] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getMoreHomeDataWithPage:(NSInteger)page
                           size:(NSInteger)size
                   successBlock:(HomeRequestSuccessBlock)successBlock
                      failBlock:(HomeRequestFailedBlock)failBlock
                       progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetHomeMoreData] refreshRequest:YES cache:NO praams:@{@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)unlockVideoWithId:(NSString *)videoId
             successBlock:(HomeRequestSuccessBlock)successBlock
                failBlock:(HomeRequestFailedBlock)failBlock
                 progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForUblockVideoWith:videoId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}



/**
 获取搜索关键词
 
 @param successBlock 成功
 @param failBlock 失败
 @param progressBlock 进度
 */
+ (void)getSearchKeyWorkWithsuccessBlock:(HomeRequestSuccessBlock)successBlock
                               failBlock:(HomeRequestFailedBlock)failBlock
                                progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetSearchKeyword] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

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
                   progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForSearchUsers] refreshRequest:YES cache:NO praams:@{@"word":word,@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];

}
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
                      progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForSearchPuhlishs] refreshRequest:YES cache:NO praams:@{@"word":word,@"page":@(page),@"size":@(size)} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];

    
}
@end
