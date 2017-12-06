//
//  XFStatusNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusNetworkManager.h"
#import "XFNetWorkManager.h"
#import "XFNetWorkApiTool.h"

@implementation XFStatusNetworkManager

/**
 关注或者取关某人
 
 @param followUserNo 对方userNumber
 @param success 成功
 @param failedBlock 失败
 */
+ (void)followSomeoneWithUserNumber:(NSString *)followUserNo successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:followUserNo forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForFollowSomeone] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 我的发布
 
 @param albumId 相册Id
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getMyPublishWithalbumId:(NSString *)albumId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:albumId forKey:@"albumId"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForMyPublish] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 我的相册
 
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getMyAlbumWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForMyPhotos] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

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
+ (void)publishStatusWithbusinType:(NSString *)businType openAlbumId:(NSString *)openAlbumId intimateAlbumId:(NSString *)intimateAlbumId opens:(NSString *)opens intimates:(NSString *)intimates files:(NSString *)files jsonString:(NSString *)jsonString  labels:(NSString *)labels jsonVideo:(NSString *)jsonVideo {
    
    
    
}

/**
 不需要登录查看的动态
 
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getStatusWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];

    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForStatusSqure] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 推荐动态
 
 @param start 开始
 @param success 成功
 @param failedBlock 失败
 */
+ (void)invitedStatusWithStart:(NSString *)start successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForInviteStatus] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 关注的动态
 
 @param success 成功
 @param failedBlock 失败
 */
+ (void)careStatusWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForCareStatus] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 获取详情
 
 @param releaseId 动态Id
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getStatusDetailWithReleaseId:(NSString *)releaseId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:releaseId forKey:@"releaseId"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForStatusDetail] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 获取我的相册
 
 @param success 成功
 @param failedBlock 失败
 */
+ (void)getAlbumIdWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForAlbumId] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 点赞
 
 @param releaseId 点赞的动态
 @param success 成功
 @param failedBlock 失败
 */
+ (void)likeStatusWithStatusId:(NSString *)releaseId successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:releaseId forKey:@"releaseId"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForLikeSomeone] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

/**
 评论
 
 @param releaseId 动态id
 @param message 内容
 @param success 成功
 @param failedBlock 失败
 */
+ (void)commentStatusWithId:(NSString *)releaseId message:(NSString *)message successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:releaseId forKey:@"releaseId"];
    [para setObject:message forKey:@"message"];

    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForCommentSomeone] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
    
}






+ (void)getMyStatusWithStart:(NSString *)start successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:start forKey:@"start"];
    [para setObject:@"10" forKey:@"rows"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetMyStatus] paraments:para successHandle:^(NSDictionary *responseDic) {
       
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

+ (void)getAllTagsWithsuccessBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetAlltags] paraments:[NSMutableDictionary dictionary] successHandle:^(NSDictionary *responseDic) {
       
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

@end
