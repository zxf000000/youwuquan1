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
        _userCache = [[YYCache alloc] initWithName:@"userInfo"];
        
        _userLong = 100.f;
        _userLati = 100.f;
    }
    return self;
}

- (void)updateLastDate:(NSString *)lastData {
    
    [_userCache setObject:lastData forKey:@"lastGetNotificationDate"];
    
}

- (NSString *)lastGetNotificationDate {
    
    return (NSString *)[_userCache objectForKey:@"lastGetNotificationDate"];
}

- (void)removeAllData {
    
    [_userCache removeAllObjects];
    
}

- (void)updateTokenDate:(NSDate *)tokenDate {
    
    [_userCache setObject:tokenDate forKey:@"tokenDate"];

}

- (NSDate *)tokenDate {
    
    return (NSDate *)[_userCache objectForKey:@"tokenDate"];
    
}

- (void)setRongToken:(NSString *)token {
    
    [_userCache setObject:token forKey:kRongTokenKey];
    
}

- (void)updateCookieWith:(NSString *)cookie {

    NSArray *cookies = [cookie componentsSeparatedByString:@";"];
    for (NSString *str in cookies) {
        
        NSArray *subcookies = [str componentsSeparatedByString:@","];
        
        for (NSString *subStr in subcookies) {
            
            if ([subStr containsString:@"JSESSIONID"]) {
                
                [_userCache setObject:subStr forKey:@"JSESSIONID"];
            }
            if ([subStr containsString:@"remember-me"]) {

                [_userCache setObject:subStr forKey:@"remember-me"];
            }
            
        }

    }

}

- (NSString *)cookie {

//    NSString *cookie = [NSString stringWithFormat:@"%@; %@",(NSString *)[_userCache objectForKey:@"JSESSIONID"],(NSString *)[_userCache objectForKey:@"remember-me"]];
    
    return (NSString *)[_userCache objectForKey:@"remember-me"];
}

- (NSString *)rongToken {
    
    return (NSString *)[_userCache objectForKey:kRongTokenKey];
    
}

- (void)updateToken:(NSString *)token {
    
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
