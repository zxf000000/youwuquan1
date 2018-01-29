//
//  XFHomeCacheManger.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeCacheManger.h"
#import "XFHomeDataModel.h"

@implementation XFHomeCacheManger

+ (instancetype)sharedManager {
    static XFHomeCacheManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XFHomeCacheManger alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _homeCache = [[YYCache alloc] initWithName:@"homeData"];
        _ywCache = [[YYCache alloc] initWithName:@"yanyuancache"];
        _whCache = [[YYCache alloc] initWithName:@"wanghongcache"];
        _videoCache = [[YYCache alloc] initWithName:@"videocache"];

    }
    return self;
}

- (void)updateNearData:(NSArray *)nearData {
    
    [self.homeCache setObject:nearData forKey:@"nearData"];
    
}

- (NSArray *)nearData {
    
    return (NSArray *)[_homeCache objectForKey:@"nearData"];
}

@end
