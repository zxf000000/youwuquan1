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
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForHomePage] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
       
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getHomeAdWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForHomeAd] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
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

+ (void)getYouwuDataWithSuccessBlock:(HomeRequestSuccessBlock)successBlock failBlock:(HomeRequestFailedBlock)failBlock progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForPrettyGirl] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
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
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForVideoPageAd] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
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
    
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForCommentVideo:videoId] refreshRequest:YES cache:NO praams:@{@"text":text} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
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
                     successBlock:(HomeRequestSuccessBlock)successBlock
                        failBlock:(HomeRequestFailedBlock)failBlock
                         progress:(HomeRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForDeleteCommentForVideo:videoId comment:commentId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
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


@end
