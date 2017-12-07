//
//  XFLoginManager.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/18.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFLoginManager.h"
//#import <Hyphenate/Hyphenate.h>



@implementation XFLoginManager


- (void)loginRongyunWithRongtoken:(NSString *)rongToken successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    // 融云登录
    [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
        
        success(userId);
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
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





- (void)saveUserIconWithfiles:(UIImage *)files successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];

    [[XFNetWorkManager sharedManager] uploadData:UIImageJPEGRepresentation(files, 0.5) url:[XFNetWorkApiTool pathUrlForSaveUserIcon] name:@"files" paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);

    } failedBlock:^(NSError *error) {
        
        failed(error);

    }];
    
}

- (void)logoutWithsuccessBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForLogout] paraments:[NSMutableDictionary dictionary] successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);

    } failedBlock:^(NSError *error) {
        
        failed(error);

    }];
    
}

- (void)getUserInfoWithsuccessBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    [parament setObject:[NSString stringWithFormat:@"%f",[XFUserInfoManager sharedManager].userLong] forKey:@"lng"];
    [parament setObject:[NSString stringWithFormat:@"%f",[XFUserInfoManager sharedManager].userLati] forKey:@"lat"];
    [[XFNetWorkManager sharedManager] postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForGetUserInfo] paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);

    } failedBlock:^(NSError *error) {
        
        failed(error);

    }];
    
    
}

- (void)loginWithuserNumber:(NSString *)userNumber token:(NSString *)token successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:token forKey:@"token"];
    [parament setObject:userNumber forKey:@"userNo"];

    
    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForLoginWithToken] paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);
        
    }];
    
}

- (void)loginWithUserNumber:(NSString *)userNumber pwd:(NSString *)pwd successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:userNumber forKey:@"userNo"];
    [parament setObject:pwd forKey:@"loginPsw"];
    [parament setObject:[NSString stringWithFormat:@"%f",[XFUserInfoManager sharedManager].userLong] forKey:@"lng"];
    [parament setObject:[NSString stringWithFormat:@"%f",[XFUserInfoManager sharedManager].userLati] forKey:@"lat"];
    
    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForLogin] paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);

    }];
}

- (void)getCodeWithPhone:(NSString *)phone regist:(NSString *)regist successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:phone forKey:@"phone"];
    [parament setObject:@"register" forKey:@"register"];

    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForGetCode] paraments:parament successHandle:^(NSDictionary *responseDic) {
       
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);
        
    }];
    
}


- (void)registWithPhone:(NSString *)phone pwd:(NSString *)pwd codeNum:(NSString *)codeNum platform:(NSString *)platform regist:(NSString *)regist successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:phone forKey:@"userNo"];
    [parament setObject:pwd forKey:@"loginPsw"];
    [parament setObject:codeNum forKey:@"vcNum"];
    [parament setObject:@"APP" forKey:@"platform"];
    [parament setObject:@"register" forKey:@"register"];

    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForRegist] paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);

        
    }];
}

- (void)changePwdWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    [parament setObject:phone forKey:@"userNo"];
    [parament setObject:pwd forKey:@"newLoginPsw"];
    [parament setObject:code forKey:@"vcNum"];
    
    
    [[XFNetWorkManager sharedManager] postUrl:[XFNetWorkApiTool pathUrlForChangePwd] paraments:parament successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);
        
        
    }];
    
}

- (void)saveUserInfoWithUserName:(NSString *)userName nickName:(NSString *)nickname birthday:(NSString *)birthday sex:(NSString *)sex tags:(NSString *)tags roleNos:(NSString *)roleNos headUrl:(NSString *)headUrl height:(NSString *)height weight:(NSString *)weight bwh:(NSString *)bwh weixin:(NSString *)weixin synopsis:(NSString *)synopsis  successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setObject:userName forKey:@"userNo"];

    
    if (nickname) {
        
        [para setObject:nickname forKey:@"userNike"];

    }
    
    if (birthday) {
        
        [para setObject:birthday forKey:@"birthday"];

    }
    
    if (tags) {
        
        [para setObject:tags forKey:@"sex"];

    }
    
    if (roleNos) {
        
        [para setObject:roleNos forKey:@"roleNos"];

    }
    
    if (headUrl) {
        
        [para setObject:headUrl forKey:@"headUrl"];

    }
    
    if (weight) {
        
        [para setObject:weight forKey:@"weight"];

    }
    
    if (bwh) {
        
        [para setObject:bwh forKey:@"bwh"];

    }
    
    if (weixin) {
        
        [para setObject:weixin forKey:@"weixin"];

    }
    
    if (synopsis) {
        
        [para setObject:synopsis forKey:@"synopsis"];

    }

    [self.networkManager postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForSaveUserInfo] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);
    }];
    
}

- (void)registSaveUserInfoWithUserName:(NSString *)userName nickName:(NSString *)nickname birthday:(NSString *)birthday sex:(NSString *)sex tags:(NSString *)tags  successBlock:(LoginSuccessBlock)success failedBlock:(LoginFailedBlock)failed {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setObject:userName forKey:@"userNo"];
    [para setObject:nickname forKey:@"userNike"];
    [para setObject:birthday forKey:@"birthday"];
    [para setObject:sex forKey:@"sex"];
    [para setObject:tags forKey:@"labels"];

    [self.networkManager postWithTokenWithUrl:[XFNetWorkApiTool pathUrlForSaveUserInfo] paraments:para successHandle:^(NSDictionary *responseDic) {
        
        success(responseDic);
        
    } failedBlock:^(NSError *error) {
        
        failed(error);
    }];
    
}

+ (instancetype)sharedInstance {

    static dispatch_once_t onceToken;
    
    static XFLoginManager *manager;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[XFLoginManager alloc] init];
    });
    return manager;
}

- (instancetype)init {

    if (self = [super init]) {
        
        _networkManager = [XFNetWorkManager sharedManager];
        
    }
    return self;
}



@end
