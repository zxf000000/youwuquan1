//
//  XFUserInfoNetWorkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFUserInfoNetWorkManager.h"
#import "XFNetWorkApiTool.h"
#import "XFNetWorkManager.h"
@implementation XFUserInfoNetWorkManager

+ (void)getAllMyStatusWithStart:(NSInteger)start successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[NSString stringWithFormat:@"%zd",start] forKey:@"start"];
    [para setObject:@"3" forKey:@"rows"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetMyStatus] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];

    
}

+ (void)getPhotoAlbumPicsWithId:(NSString *)albumId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:albumId forKey:@"albumId"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForMyPublish] paraments:para successHandle:^(NSDictionary *responseDic) {
       
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

+ (void)uploadImgTowallWithImages:(NSArray *)imgs SuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    [[XFNetWorkManager sharedManager] publishUploadWithUrl:[XFNetWorkApiTool pathUrlForUploadImgToWall] imgs:imgs name:@"files" paraments:[NSMutableDictionary dictionary] successHandle:^(NSDictionary *responseDic) {
       
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

+ (void)getAllSkillsWithSuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetAllSkills] paraments:[NSMutableDictionary dictionary] successHandle:^(NSDictionary *responseDic) {
       
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

+ (void)getUserSkillsWithSuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForSkillList] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
    
}

+ (void)changeOrlightSkillWithSkillno:(NSString *)skillNo inviteTime:(NSString *)inviteTime invitePlace:(NSString *)invitePlace inviteMoney:(NSString *)inviteMoney inviteDemand:(NSString *)inviteDemand successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    [jsonDic setObject:skillNo forKey:@"skillNo"];
    [jsonDic setObject:inviteTime forKey:@"inviteTime"];
    [jsonDic setObject:invitePlace forKey:@"invitePlace"];
    [jsonDic setObject:inviteMoney forKey:@"inviteMoney"];
    [jsonDic setObject:inviteDemand forKey:@"inviteDemand"];
    [jsonDic setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    NSString *jsonString = [XFToolManager DataTOjsonString:jsonDic];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setObject:jsonString forKey:@"jsonString"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForCHangeSkill] paraments:para successHandle:^(NSDictionary *responseDic) {
       
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getMyMoneyInfoWithsuccessBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetMyMoneyInfo] paraments:para successHandle:^(NSDictionary *responseDic) {
       
        successBlock(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failedBlock(error);
    }];
}


@end
