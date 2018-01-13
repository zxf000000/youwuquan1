//
//  XFMessageCacheManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/13.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMessageCacheManager : NSObject

@property (nonatomic,strong) YYCache *msgCache;

+ (instancetype)sharedManager;

@property (nonatomic,copy) NSArray *hudongMsgs;

@property (nonatomic,copy) NSArray *zongheMsgs;

@property (nonatomic,copy) NSArray *systermMsgs;

- (void)updateCacheWith:(NSDictionary *)info;

- (void)updateHuDongMsgWith:(NSDictionary *)dic;
- (void)updateZongHeMsgWith:(NSDictionary *)dic;
- (void)updateSystermMsgWith:(NSDictionary *)dic;

@end
