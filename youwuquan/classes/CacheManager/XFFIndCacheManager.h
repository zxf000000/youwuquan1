//
//  XFFIndCacheManager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFFIndCacheManager : NSObject
@property (nonatomic,strong) YYCache *findCache;

@property (nonatomic,strong) YYCache *inviteCache;


@property (nonatomic,copy) NSArray *findData;

@property (nonatomic,copy) NSArray *inviteData;

@property (nonatomic,copy) NSArray *searchData;

+ (instancetype)sharedManager;

- (void)removeAllData;



@end
