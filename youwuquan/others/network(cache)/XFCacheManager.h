//
//  XFCacheManager.h
//  yuebuyueNetwork
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCacheManager : NSObject


/**
 默认磁盘存储40M,缓存有效期是7天

 @return manager
 */
+ (XFCacheManager *)sharedManager;

/**
 设置缓存时间和缓存的磁盘空间

 @param time 缓存时间
 @param capacity 磁盘空间
 */
- (void)setCacheTime:(NSTimeInterval)time diskCapacity:(NSUInteger)capacity;

/**
 缓存相应数据

 @param responseObject 响应数据
 @param requesrUrl 请求url
 @param params 请求参数
 */
- (void)cacheResponseObject:(id)responseObject requestUrl:(NSString *)requestUrl params:(NSDictionary *)params;


/**
 获取响应数据

 @param requestUrl 请求url
 @param params 请求参数
 */
- (id)getCacheResponseObjectWithResponseUrl:(NSString *)requestUrl params:(NSDictionary *)params;


/**
 存储下载文件

 @param data 文件数据
 @param requestUrl 请求url
 */
- (void)storDownloadData:(NSData *)data requestUrl:(NSString *)requestUrl;
/**
 获取磁盘中的下载文件

 @param requestUrl 请求url
 @return 本地文件存储路径
 */
- (NSURL *)getDownloadDataFromCacheWithRequestUrl:(NSString *)requestUrl;

/**
 获取缓存目录路径

 @return 缓存目录路径
 */
- (NSString *)getCacheDiretoryPath;

/**
 获取下载目录路径

 @return 下载目录路径
 */
- (NSString *)getDownloadDirtoryPath;


/**
 获取缓存大小

 @return 缓存大小
 */
- (NSUInteger)totalCacheSize;

/**
 清除所有缓存
 */
- (void)clearTotalChache;

/**
 清除最近少使用的缓存,用LRU算法实现
 */
- (void)clearLRUCache;

@end
