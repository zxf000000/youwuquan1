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
 */
+ (void)publishStatusWithopenAlbumId:(NSString *)openAlbumId intimateAlbumId:(NSString *)intimateAlbumId opens:(NSArray *)opens intimates:(NSArray *)intimates type:(NSString *)type title:(NSString *)title unlockNum:(NSString *)unlockNum customLabel:(NSString *)customLabel labels:(NSString *)labels successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock  progress:(ProgressBlock)progressblock {
    
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    [jsonDic setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [jsonDic setObject:type forKey:@"type"];
    [jsonDic setObject:title forKey:@"title"];
    [jsonDic setObject:unlockNum forKey:@"unlockNum"];
    if (customLabel) {
        
        [jsonDic setObject:customLabel forKey:@"customLabel"];
        
    }
    NSString *jsonString = [self DataTOjsonString:jsonDic];
    

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:openAlbumId forKey:@"openAlbumId"];
    [para setObject:intimateAlbumId forKey:@"intimateAlbumId"];
    [para setObject:jsonString forKey:@"jsonString"];
    [para setObject:@"1,2" forKey:@"labels"];
    
    [[XFNetWorkManager sharedManager] publishUploadWithUrl:[XFNetWorkApiTool pathUrlForPublish] Opens:opens secs:intimates paraments:para successHandle:^(NSDictionary *responseDic) {
       
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    } progress:^(CGFloat progress) {
        
        progressblock(progress);
        
    }];
    

    
    
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

    
    [para setObject:releaseId ? releaseId:@"147" forKey:@"releaseId"];
    
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
+ (void)likeStatusWithStatusId:(NSString *)releaseId userNo:(NSString *)userNo successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    if (userNo) {
        
        [para setObject:userNo forKey:@"userNoA"];

    }
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
+ (void)commentStatusWithId:(NSString *)releaseId message:(NSString *)message userNoA:(NSString *)userNoA successBlock:(RequestSuccessBlock)success failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [para setObject:releaseId ? releaseId:@"147" forKey:@"releaseId"];
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

+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
