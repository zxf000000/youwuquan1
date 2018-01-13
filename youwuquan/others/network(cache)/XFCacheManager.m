//
//  XFCacheManager.m
//  yuebuyueNetwork
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCacheManager.h"
#import <CommonCrypto/CommonDigest.h>


static NSString *const cacheDirkey = @"cacheDirKey";
static NSString *const downloadDirKey = @"downloadDirKey";
static NSUInteger diskCapacity = 40 * 1024 * 1024;
static NSTimeInterval cacheTime = 7 * 24 * 60 * 60;

@implementation XFCacheManager

+ (XFCacheManager *)sharedManager {
    
    static XFCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XFCacheManager alloc] init];
    });
    return manager;
}

- (void)setCapacityTime:(NSTimeInterval)time diskCapacity:(NSUInteger)capacity {
    
    diskCapacity = capacity;
    cacheTime = time;
    
//    [kNetworkCache.memoryCache setCountLimit:50];//内存最大缓存数据个数
    [kNetworkCache.memoryCache setCostLimit:diskCapacity];//内存最大缓存开销 目前这个毫无用处
    [kNetworkCache.diskCache setCostLimit:diskCapacity];//磁盘最大缓存开销
//    [kNetworkCache.diskCache setCountLimit:50];//磁盘最大缓存数据个数
    [kNetworkCache.diskCache setAutoTrimInterval:cacheTime];//设置磁盘lru动态清理频率 默认 60秒
    
}

- (void)cacheResponseObject:(id)responseObject requestUrl:(NSString *)requestUrl params:(NSDictionary *)params {
    
    assert(responseObject);
    assert(requestUrl);
    
    if (!params) params = @{};
    
    NSString *originString = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    NSData *data = nil;
    NSError *error = nil;
    if (![responseObject isKindOfClass:[NSData class]]) {
        
        data = responseObject;
    } else {
        
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:(NSJSONWritingPrettyPrinted) error:&error];
        
    }
    
    if (error == nil) {
        
        // 缓存到内存
//        [XFMemoryCache writeData:responseObject forKey:hash];
        
        // 缓存到磁盘
        [kNetworkCache setObject:responseObject forKey:hash];
        
    }
}

- (id)getCacheResponseObjectWithResponseUrl:(NSString *)requestUrl params:(NSDictionary *)params {
    
    assert(requestUrl);
    
    id cacheData = nil;
    
    if (!params) params = @{};
    NSString *originString = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    //先从内存中查找
    cacheData = [kNetworkCache objectForKey:hash];
    
    if (!cacheData) {

        cacheData = [kNetworkCache objectForKey:hash];
        
    }
    
    return cacheData;
}

- (void)storDownloadData:(NSData *)data requestUrl:(NSString *)requestUrl {
    
    assert(data);
    
    assert(requestUrl);
    
    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    
    strArray = [requestUrl componentsSeparatedByString:@"."];
    
    if (strArray.count > 0) {
        
        type = strArray[strArray.count - 1];
        
    }
    
    if (type) {
        
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    
    } else {
        
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
        
    }
    
    [kNetworkCache setObject:data forKey:fileName];
    
}

- (NSURL *)getDownloadDataFromCacheWithRequestUrl:(NSString *)requestUrl {
    
    assert(requestUrl);
    
    NSData *data = nil;
    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    NSURL *fileUrl = nil;
    
    strArray = [requestUrl componentsSeparatedByString:@"."];
    if (strArray.count > 0) {
        type = strArray[strArray.count - 1];
    }
    
    if (type) {
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    }else {
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
    }
    
    if ([kNetworkCache objectForKey:fileName]) {
        
        data = (NSData *)[kNetworkCache objectForKey:fileName];
        
    }
    
    if (data) {
        
        NSString *path = [[[kNetworkCache diskCache] path] stringByAppendingPathComponent:fileName];
        
        fileUrl = [NSURL URLWithString:path];
    }

    return fileUrl;
}

- (NSUInteger)totalCacheSize {
    
    return [[kNetworkCache diskCache] totalCost];
    
}
- (NSUInteger)totalDownloadDataSize {

    return [[kNetworkCache diskCache] totalCost];
}

- (void)clearTotalCache {

    [kNetworkCache removeAllObjects];
}

#pragma mark - 散列值
- (NSString *)md5:(NSString *)string {
        if (string == nil || string.length == 0) {
            return nil;
        }
        
        unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
        
        CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
        
        NSMutableString *ms = [NSMutableString string];
        
        for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [ms appendFormat:@"%02x",(int)(digest[i])];
        }
        
        return [ms copy];
}

@end
