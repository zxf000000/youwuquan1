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
#import <AFHTTPSessionManager.h>

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
    
    NSDictionary *params = @{@"username":phone,
                             @"password":pwd,
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

+ (void)signUpWithType:(NSString *)type username:(NSString *)username token:(NSString *)token phone:(NSString *)phone code:(NSString *)code progress:(LoginRequestProgressBlock)progressBlock successBlock:(LoginRequestSuccessBlock)successBlock failBlock:(LoginRequestFailedBlock)failBlock {
    
        
        NSDictionary *params = @{@"username":username,
                                 @"token":token,
                                 @"phone":phone,
                                 @"code":code
                                 };
        NSLog(@"%@",type);
    
    // 微信返回xml,所以要另外设置
    if ([type isEqualToString:@"WeChat"]) {
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*",
                                                                                  @"text/*",
                                                                                  @"application/octet-stream",
                                                                                  @"application/zip"]];
        [manager POST:[XFApiClient pathUrlForChargeWithAlipay] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
//            successBlock(str);
            // 获取融云
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
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failBlock(error);
            
        }];
        
    } else {
        [XFNetworking postWithUrl:[XFApiClient pathUrlForSignupWith:type] refreshRequest:NO cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
            
            progressBlock(bytesRead/(CGFloat)totalBytes);
            
        } successBlock:^(id response) {
            
            // 获取融云
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
    
    

        
    
}

+ (void)checkIsHasUserWith:(NSString *)uid
              successBlock:(LoginRequestSuccessBlock)success
               failedBlock:(LoginRequestFailedBlock)failed {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForCheckIsHasUserWith:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        success(response);

    } failBlock:^(NSError *error) {
        failed(error);

    }];
    
}

/**
 刷新/获取token
 
 @param success 0
 @param failed 0
 */
+ (void)getMyTokenWithsuccessBlock:(LoginRequestSuccessBlock)success
                       failedBlock:(LoginRequestFailedBlock)failed {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetMyToken] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        success(response);
        
    } failBlock:^(NSError *error) {
        failed(error);
        
    }];
    
}


/**
 token登录
 
 @param token token
 @param success 0
 @param failed 0
 */
+ (void)loginWithToken:(NSString *)token
          successBlock:(LoginRequestSuccessBlock)success
           failedBlock:(LoginRequestFailedBlock)failed {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLoginWithToken] refreshRequest:YES cache:NO praams:@{@"token":token} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        
        // 刷新个人信息
        success(response);
        
    } failBlock:^(NSError *error) {
        failed(error);
        
    }];
    
}


@end
