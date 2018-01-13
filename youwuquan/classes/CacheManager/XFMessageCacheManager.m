//
//  XFMessageCacheManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/13.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFMessageCacheManager.h"
#define kHuDongMsgCache @"hudongmsg"
#define kZongheMsgCache @"zongheMsg"
#define kSystermMsgCache @"systermMsg"

@implementation XFMessageCacheManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static XFMessageCacheManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[XFMessageCacheManager alloc] init];
    });
    
    return manager;
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _msgCache = [YYCache cacheWithName:@"messageCache"];
        
    }
    return self;
}

- (void)updateCacheWith:(NSDictionary *)info {
    
    [self updateHuDongMsgWith:info];
    
}

- (void)updateHuDongMsgWith:(NSDictionary *)dic {
    
    NSArray *datas = (NSArray *)[self.msgCache objectForKey:kHuDongMsgCache];
    if (datas == nil) {
        
        datas = [NSArray array];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datas];
    [arr addObject:dic];
    
    [self.msgCache setObject:arr.copy forKey:kHuDongMsgCache];
    
}

- (void)updateZongHeMsgWith:(NSDictionary *)dic {
    
    NSArray *datas = (NSArray *)[self.msgCache objectForKey:kZongheMsgCache];
    if (datas == nil) {
        
        datas = [NSArray array];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datas];
    [arr addObject:dic];
    
    [self.msgCache setObject:arr.copy forKey:kZongheMsgCache];
    
}

- (void)updateSystermMsgWith:(NSDictionary *)dic {
    
    NSArray *datas = (NSArray *)[self.msgCache objectForKey:kSystermMsgCache];
    if (datas == nil) {
        
        datas = [NSArray array];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datas];
    [arr addObject:dic];
    
    [self.msgCache setObject:arr.copy forKey:kSystermMsgCache];
}

@end
