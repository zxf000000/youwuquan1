//
//  XFUserInfoManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/25.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFUserInfoManager.h"

@implementation XFUserInfoManager

+ (instancetype)sharedManager {
    static XFUserInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XFUserInfoManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userCache = [[YYCache alloc] initWithName:@"userInfo"];
    }
    return self;
}

- (void)removeAllData {
    
    [_userCache removeAllObjects];
    
}

- (void)setRongToken:(NSString *)token {
    
    [_userCache setObject:token forKey:kRongTokenKey];
    
}

- (NSString *)rongToken {
    
    return (NSString *)[_userCache objectForKey:kRongTokenKey];
    
}

- (void)setToken:(NSString *)token {
    
    [_userCache setObject:token forKey:kUserTokenKey];
    
}

- (NSString *)token {
    
    return (NSString *)[_userCache objectForKey:kUserTokenKey];
    
}

- (void)setUserName:(NSString *)userName {
    
    [_userCache setObject:userName forKey:kUserNameKey];
    
}

- (NSString *)userName {
    
    return (NSString *)[_userCache objectForKey:kUserNameKey];
    
}

- (NSString *)pwd {
    
    return [YYKeychain getPasswordForService:kAppServiceKey account:self.userName error:nil];

    
}

- (void)setPwd:(NSString *)pwd {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [YYKeychain setPassword:pwd forService:kAppServiceKey account:self.userName];
    
}

- (void)updateUserInfo:(id)userInfo {
    [self.userCache setObject:userInfo forKey:@"info"];
}

- (NSDictionary *)userInfo {
    if (!_userInfo) {
        id value = [self.userCache objectForKey:@"info"];
        NSDictionary *userInfo = (NSDictionary *)value;
        return userInfo;
    }
    return _userInfo;
}


@end
