//
//  XFHomeCacheManger.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache.h>

@interface XFHomeCacheManger : NSObject

@property (nonatomic,strong) YYCache *homeCache;

@property (nonatomic,strong) YYCache *ywCache;

@property (nonatomic,strong) YYCache *whCache;

@property (nonatomic,strong) YYCache *videoCache;

@property (nonatomic,strong) NSArray *homeData;

@property (nonatomic,strong) NSArray *ywData;
@property (nonatomic,strong) NSArray *whData;

@property (nonatomic,strong) NSArray *videoData;

+ (instancetype)sharedManager;

- (void)removeAllData;


@end
