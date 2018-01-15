//
//  XFLoginNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLoginNetworkManager.h"
#import "XFNetworking.h"
#import "XFApiClient.h"
#import <JPUSHService.h>


@implementation XFLoginNetworkManager

+ (void)getCodeWithPhoneNumber:(NSString *)phoneNumber progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForSendCodeWithNumber:phoneNumber] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
    
}

+ (void)registWithPhone:(NSString *)phoneNumber pwd:(NSString *)pwd code:(NSString *)code progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    NSDictionary *params = @{@"username":phoneNumber,
                             @"phone":phoneNumber,
                             @"password":pwd,
                             @"code":code
                             };
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForSignup] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);

    } successBlock:^(id response) {
        
        successBlock(response);

    } failBlock:^(NSError *error) {
        
        failBlock(error);

    }];
    
}

+ (void)changePwdWithNewPwd:(NSString *)pwd progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    NSDictionary *params = @{@"password":pwd};
    
    [XFNetworking putWithUrl:[XFApiClient pathUrlForResetPwd] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        
    } successBlock:^(id response) {
        
        successBlock(response);

    } failBlock:^(NSError *error) {
        
        failBlock(error);

    }];
    
}

+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd longitude:(NSString *)longitude latitude:(NSString *)latitude progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    NSDictionary *params = @{@"phone":phone,
                             @"password":[XFToolManager md5:pwd],
                             @"remember-me":@(YES),
                             @"longitude":@([longitude doubleValue]),
                             @"latitude":@([latitude doubleValue])
                             };
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLogin] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
//        successBlock(response);
        // 成功之后获取融云token
        [self getImTokenWithprogress:^(CGFloat progress) {


        } successBlock:^(id responseObj) {
            
            NSString *token = responseObj[@"token"];
            
            // 成功之后登录融云
            [self loginRongyunWithRongtoken:token successBlock:^(id responseObj) {

                [XFUserInfoManager sharedManager].rongToken = token;
                
                successBlock(responseObj);

            } failedBlock:^(NSError *error) {

                failBlock(error);

            }];

        } failBlock:^(NSError *error) {

            failBlock(error);

        }];
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)logoutWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLogout] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)getImTokenWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetImToken] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)loginRongyunWithRongtoken:(NSString *)rongToken successBlock:(LoginRequestSuccessBlock)success failedBlock:(LoginRequestFailedBlock)failed {
    
    // 融云登录
    [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
        
        success(userId);
        
        // 个人信息
        // 设置当前登录用户信息
//        NSDictionary *userInfo = [XFUserInfoManager sharedManager].userInfo;
//
//        RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:[XFUserInfoManager sharedManager].userName name:userInfo[kUserNickKey] portrait:userInfo[kUserIconKey]];
//
//        [RCIM sharedRCIM].currentUserInfo = info;
//
        
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);

        
        [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSLog(@"设置别名---%zd-----%@-----%zd",iResCode,iAlias,seq);
            
            NSLog(@"设置别名成功");
        } seq:[userId integerValue]];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
        
        failed(nil);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        failed(nil);
        
    }];
    
    
}

+ (void)saveUserInfoWithnickName:(NSString *)nickName birthday:(NSString *)birthday sex:(NSString *)sex progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    // 修改个人信息
    NSDictionary *params = @{@"birthDay":birthday,
                             @"nickname":nickName
                             };
    
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForUpdateUserInfo] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        // 修改性别
        
        [self saveSexWithSex:sex progress:^(CGFloat progress) {
            
            progressBlock(progress);

        } successBlock:^(id responseObj) {
            
            successBlock(response);

        } failBlock:^(NSError *error) {
            
            failBlock(error);

        }];
        
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}

+ (void)saveSexWithSex:(NSString *)sex progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
 
    NSDictionary *params = @{@"gender":sex};
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForSetSex] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
}

+ (void)getAllTagsWithprogress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetAllTag] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failBlock(error);
        
    }];
    
}


@end