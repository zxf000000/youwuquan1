//
//  XFFIndCacheManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFIndCacheManager.h"
#import "XFStatusModel.h"

@implementation XFFIndCacheManager

+ (instancetype)sharedManager {
    static XFFIndCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XFFIndCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _findCache = [[YYCache alloc] initWithName:@"findCache"];
        _inviteCache = [[YYCache alloc] initWithName:@"inviteCache"];

        
    }
    return self;
}



@end
