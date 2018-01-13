//
//  XFNetworking.h
//  yuebuyueNetwork
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络状态
 
 - XFNetworkStatusUnknow: 未知网络
 - XFNetworkStatusNotReachable: 无法连接
 - XFNetworkStatusReachableWAN: WAN网络
 - XFNetworkStatusReachableViaWifi: wifi网络
 */
typedef NS_ENUM(NSInteger,XFNetworkStatus) {
    
    XFNetworkStatusUnknow           = 1 << 0,
    XFNetworkStatusNotReachable     = 1 << 1,
    XFNetworkStatusReachableWAN     = 1 << 2,
    XFNetworkStatusReachableViaWifi = 1 << 3
    
    
};
// 请求任务
typedef NSURLSessionTask XFURLSEssionTask;

// 成功回调
typedef void(^XFRequestSuccessBlock)(id response);
// 失败回调
typedef void(^XFRequestFailBlock)(NSError *error);

/**
 下载进度
 
 @param bytesRead 已下载大小
 @param totalBytes 总大小
 */
typedef void(^XFDownloadProgress)(int64_t bytesRead,int64_t totalBytes);

/**
 下载成功回调
 
 @param url 保存路径
 */
typedef void(^XFDownloadSuccessBlock)(NSURL *url);

/**
 上传进度
 
 @param bytesWriten 上传大小
 @param totalBytes 总大小
 */
typedef void(^XFUploadProgressBlock)(int64_t bytesWriten, int64_t totalBytes);
/**
 *  多文件上传成功回调
 *
 *  @param responses 成功后返回的数据
 */
typedef void(^XFMultUploadSuccessBlock)(NSArray *responses);

/**
 *  多文件上传失败回调
 *
 *  @param errors 失败后返回的错误信息
 */
typedef void(^XFMultUploadFailBlock)(NSArray *errors);

typedef XFDownloadProgress XFGetPeogress;

typedef XFDownloadProgress XFPostProgress;

typedef XFRequestFailBlock XFDownloadFailedBlock;


@interface XFNetworking : NSObject

/**
 正在运行的网路哦任务
 
 @return tasks
 */
+ (NSArray *)currentRunningTasks;

/**
 配置请求头
 
 @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 取消get请求
 
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 取消所有请求
 */
+ (void)cancelAllRequest;

/**
 设置超时时间内

 @param timeout 超时事件
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 delete请求

 @param url 请求路径
 @param refresh 是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请求，用旧请求)
 @param cache 是否环迅
 @param params 拼接参数
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failBlock 失败回调
 @return 返回对象中可取消请求
 */
+ (XFURLSEssionTask *)deleteWithUrl:(NSString *)url
                     refreshRequest:(BOOL)refresh
                              cache:(BOOL)cache
                             praams:(NSDictionary *)params
                      progressBlock:(XFGetPeogress)progressBlock
                       successBlock:(XFRequestSuccessBlock)successBlock
                          failBlock:(XFRequestFailBlock)failBlock;

/**
 GET请求

 @param url 请求路径
 @param refresh 是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请求，用旧请求)
 @param cache 是否环迅
 @param params 拼接参数
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failBlock 失败回调
 @return 返回对象中可取消请求
 */
+ (XFURLSEssionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          praams:(NSDictionary *)params
                   progressBlock:(XFGetPeogress)progressBlock
                    successBlock:(XFRequestSuccessBlock)successBlock
                       failBlock:(XFRequestFailBlock)failBlock;

/**
 post请求

 @param url 请求路径
 @param refresh 是否刷新
 @param cache 是否缓存
 @param params 参数
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failBlock 失败回调
 @return 返回任务请求
 */
+ (XFURLSEssionTask *)postWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          praams:(NSDictionary *)params
                   progressBlock:(XFGetPeogress)progressBlock
                    successBlock:(XFRequestSuccessBlock)successBlock
                       failBlock:(XFRequestFailBlock)failBlock;



/**
 PUT请求

 @param url 路径
 @param refresh 是否刷新
 @param cache 是否缓存
 @param params 参数
 @param progressBlock 进度
 @param successBlock 成功
 @param failBlock 失败
 @return 返回
 */
+ (XFURLSEssionTask *)putWithUrl:(NSString *)url refreshRequest:(BOOL)refresh cache:(BOOL)cache praams:(NSDictionary *)params progressBlock:(XFGetPeogress)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock;

/**
 上传文件

 @param url 上传地址
 @param data 上传数据
 @param type 上传文件类型
 @param name 上传文件服务器文件夹名
 @param mimeType mimetype
 @param progressBlock 上传文件进度
 @param successBlock 成功
 @param failBlock 失败
 @return 任务请求
 */
+ (XFURLSEssionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(XFUploadProgressBlock)progressBlock
                           successBlock:(XFRequestSuccessBlock)successBlock
                              failBlock:(XFRequestFailBlock)failBlock;



/**
 *  多文件上传
 *
 *  @param url           上传文件地址
 *  @param datas         数据集合
 *  @param type          类型
 *  @param name          服务器文件夹名
 *  @param mimeTypes      mimeTypes
 *  @param progressBlock 上传进度
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return 任务集合
 */
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(XFUploadProgressBlock)progressBlock
                      successBlock:(XFMultUploadSuccessBlock)successBlock
                         failBlock:(XFMultUploadSuccessBlock)failBlock;

/**
 *  文件下载
 *
 *  @param url           下载文件接口地址
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
+ (XFURLSEssionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(XFDownloadProgress)progressBlock
                         successBlock:(XFDownloadSuccessBlock)successBlock
                            failBlock:(XFDownloadFailedBlock)failBlock;

/**
 上传认证信息

 @param url url
 @param datas 数据
 @param type 类型
 @param names 名称
 @param mimeType 类型
 @param progressBlock 查进度
 @param successBlock 成功
 @param failBlock 失败
 @return task
 */
+ (XFURLSEssionTask *)uploadDefineFileWithUrl:(NSString *)url fileData:(NSArray *)datas type:(NSString *)type name:(NSArray *)names mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock;


/**
 发布动态

 @param url url
 @param images 图片
 @param type 类型
 @param name 名字
 @param mimeType 类型
 @param params 参数
 @param progressBlock 成功
 @param successBlock 成功
 @param failBlock 失败
 @return task
 */
+ (XFURLSEssionTask *)publishStatusWithUrl:(NSString *)url images:(NSArray *)images type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock;

/**
 多图上传--同意名称

 @param url url
 @param datas 数据
 @param type 类型
 @param name 名字
 @param mimeType 图片类型
 @param params 参数
 @param progressBlock 成功
 @param successBlock 失败
 @param failBlock 进度
 @return task
 */
+ (XFURLSEssionTask *)uploadMutableWithUrl:(NSString *)url fileData:(NSArray *)datas type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock;

@end


@interface XFNetworking (cache)

/**
 获取缓存目录路径

 @return 缓存目录路径
 */
+ (NSString *)getCacheDiretoryPath;


/**
 获取下载目录lujing

 @return 下载目录路径
 */
+ (NSString *)getDownDirectoryPath;

/**
 获取缓存大小

 @return 缓存大小
 */
+ (NSUInteger)totalCacheSize;

/**
 清除所有缓存
 */
+ (void)clearTotalCache;

/**
 获取所有下载数据量大小

 @return 下载数据量大小
 */
+ (NSUInteger)totalDownloadDataSize;

/**
 清除下载数据
 */
+ (void)clearDownloadData;

@end











