//
//  XFNetworking.m
//  yuebuyueNetwork
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNetworking.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "XFCacheManager.h"
#import "XFNetworking+RequestManager.h"
#import "XFLoginVCViewController.h"
#import "XFApiClient.h"

#define YQ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"
#define YQ_ERROR [NSError errorWithDomain:@"com.hyq.YQNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:YQ_ERROR_IMFORMATION}]


static NSMutableArray *requestTaskPool;
static NSDictionary *headers;
static XFNetworkStatus networkStatus;
static NSTimeInterval requestTimeout = 20.f;

@implementation XFNetworking

#pragma mark - manager


+ (AFHTTPSessionManager *)sessionmanager {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    static AFHTTPSessionManager *manager;
    manager = [AFHTTPSessionManager manager];
    // 默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 配置相应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];

    // 配置请求序列化
    manager.requestSerializer.timeoutInterval = requestTimeout;

    [self checkNetworkStatus];
    return manager;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = XFNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = XFNetworkStatusUnknow;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = XFNetworkStatusReachableWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = XFNetworkStatusReachableViaWifi;
                break;
                
        }
        
    }];
    
    
}

+ (NSMutableArray *)allTasks {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTaskPool == nil) requestTaskPool = [NSMutableArray array];
    });
    
    return requestTaskPool;
}
#pragma mark - delete
+ (XFURLSEssionTask *)deleteWithUrl:(NSString *)url
                     refreshRequest:(BOOL)refresh
                              cache:(BOOL)cache
                             praams:(NSDictionary *)params
                      progressBlock:(XFGetPeogress)progressBlock
                       successBlock:(XFRequestSuccessBlock)successBlock
                          failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        
        if (failBlock) failBlock(YQ_ERROR);
        
        return session;
        
    }
    
    id responseObj = [[XFCacheManager sharedManager] getCacheResponseObjectWithResponseUrl:url params:params];
    
    if (responseObj && cache) {
        
        if (successBlock) {
            successBlock(responseObj);
        }
    }
    
    session  =[manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (successBlock) successBlock(responseObject);

        if (cache) {
            
            [[XFCacheManager sharedManager] cacheResponseObject:responseObject requestUrl:url params:params];
            
            [[self allTasks] removeObject:session];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) {
            failBlock(error);
        }
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
        } success:^{
            
            
        }];
        
        [[self allTasks] removeObject:session];
        
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        
        [session cancel];
        
        return session;
    } else {
        
        // 无论是否有旧请求,先取消
        XFURLSEssionTask *oldtask = [self cancelSameRequestTasksPool:session];
        
        if (oldtask) [[self allTasks] removeObject:oldtask];
        if (session) [[self allTasks] addObject:session];
        
        [session resume];
        
        return session;
    }
    
    
    return nil;
    
}

#pragma mark - get
+ (XFURLSEssionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          praams:(NSDictionary *)params
                   progressBlock:(XFGetPeogress)progressBlock
                    successBlock:(XFRequestSuccessBlock)successBlock
                       failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        
        if (failBlock) failBlock(YQ_ERROR);
        
        return session;
        
    }
    
    id responseObj = [[XFCacheManager sharedManager] getCacheResponseObjectWithResponseUrl:url params:params];
    
    if (responseObj && cache) {
        
        if (successBlock) {
            
            successBlock(responseObj);
            
        }
    }
    
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [self updateCookieForUrl:nil];
        
        if (successBlock) successBlock(responseObject);

        if (cache) {
            
            [[XFCacheManager sharedManager] cacheResponseObject:responseObject requestUrl:url params:params];
            
            [[self allTasks] removeObject:session];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@",error);
        
        if (failBlock) {
            failBlock(error);
        }
        
            [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
                
            } success:^{
                
                if (failBlock) failBlock(nil);
                
            }];

        
        [[self allTasks] removeObject:session];
        
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {

        [session cancel];

        return session;

    } else {

        // 无论是否有旧请求,先取消
        XFURLSEssionTask *oldtask = [self cancelSameRequestTasksPool:session];

        if (oldtask) [[self allTasks] removeObject:oldtask];
        if (session) [[self allTasks] addObject:session];

        [session resume];

        return session;
    }
    
    
    return nil;
    
}

#pragma mark - put
+ (XFURLSEssionTask *)putWithUrl:(NSString *)url refreshRequest:(BOOL)refresh cache:(BOOL)cache praams:(NSDictionary *)params progressBlock:(XFGetPeogress)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    id responseObj = [[XFCacheManager sharedManager] getCacheResponseObjectWithResponseUrl:url params:params];
    
    if (responseObj && cache) {
        
        if (successBlock) {
            successBlock(responseObj);
        }
        
    }
    
    session = [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) successBlock(responseObject);
        if (cache) [[XFCacheManager sharedManager] cacheResponseObject:responseObject requestUrl:url params:params];
        
        if ([[self allTasks] containsObject:session]) {
            [[self allTasks] removeObject:session];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{

        } success:^{
            
            
        }];
        
        [[self allTasks] removeObject:session];
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        [session cancel];
        return session;
    }else {
        XFURLSEssionTask *oldTask = [self cancelSameRequestTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
    
}

#pragma mark - post
+ (XFURLSEssionTask *)postWithUrl:(NSString *)url refreshRequest:(BOOL)refresh cache:(BOOL)cache praams:(NSDictionary *)params progressBlock:(XFGetPeogress)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    __block AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    id responseObj = [[XFCacheManager sharedManager] getCacheResponseObjectWithResponseUrl:url params:params];
    
    if (responseObj && cache) {
        
        if (successBlock) {
            successBlock(responseObj);
        }
        
    }
    
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                         uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) successBlock(responseObject);

        if (cache) [[XFCacheManager sharedManager] cacheResponseObject:responseObject requestUrl:url params:params];
        
        if ([[self allTasks] containsObject:session]) {
            [[self allTasks] removeObject:session];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
        } success:^{
            
            if (failBlock) failBlock(nil);
            
        }];
        
        NSLog(@"%@",error.description);
        
        [[self allTasks] removeObject:session];
        
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        [session cancel];
        return session;
    }else {
        XFURLSEssionTask *oldTask = [self cancelSameRequestTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
    
}

#pragma mark - 发布动态
+ (XFURLSEssionTask *)publishStatusWithUrl:(NSString *)url images:(NSArray *)images type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    manager.requestSerializer.timeoutInterval = 100.f;
    
    session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < images.count ; i ++ ) {
            
            NSLog(@"%@---image",images[i]);
            
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%zd.jpg",dateString,i];\
            
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"images" fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        NSLog(@"%zd / %zd",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (successBlock) successBlock(responseObject);

        [[self allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
        } success:^{
            
            
        }];
        
        [[self allTasks] removeObject:session];
    }];

    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 认证信息上传
+ (XFURLSEssionTask *)uploadDefineFileWithUrl:(NSString *)url fileData:(NSArray *)datas type:(NSString *)type name:(NSArray *)names mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    manager.requestSerializer.timeoutInterval = 50.f;
    
    session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < datas.count ; i ++ ) {
            
            NSString *fileName = nil;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *day = [formatter stringFromDate:[NSDate date]];
            
            fileName = [NSString stringWithFormat:@"%@.%@%zd",day,type,i];
            
            [formData appendPartWithFileData:datas[i] name:names[i] fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (successBlock) successBlock(responseObject);

        [[self allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
        } success:^{
            
            
        }];
        [[self allTasks] removeObject:session];
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 文件上传
+ (XFURLSEssionTask *)uploadFileWithUrl:(NSString *)url fileData:(NSData *)data type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeType progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    session = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileName = nil;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *day = [formatter stringFromDate:[NSDate date]];
        
        fileName = [NSString stringWithFormat:@"%@.%@",day,type];
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (successBlock) successBlock(responseObject);

        [[self allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
        } success:^{
            
            
        }];
        
        [[self allTasks] removeObject:session];
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 多图上传
+ (XFURLSEssionTask *)uploadMutableWithUrl:(NSString *)url fileData:(NSArray *)datas type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeType  params:(NSDictionary *)params progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFRequestSuccessBlock)successBlock failBlock:(XFRequestFailBlock)failBlock {
    
    __block XFURLSEssionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    manager.requestSerializer.timeoutInterval = 100.f;
    
    session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < datas.count ; i ++ ) {
            
            NSString *fileName = nil;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *day = [formatter stringFromDate:[NSDate date]];
            
            fileName = [NSString stringWithFormat:@"%@.%@%zd",day,type,i];
            
            [formData appendPartWithFileData:datas[i] name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) successBlock(responseObject);

        [[self allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) failBlock(error);
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
        
            
        } success:^{
            
            
        }];
        [[self allTasks] removeObject:session];
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url fileDatas:(NSArray *)datas type:(NSString *)type name:(NSString *)name mimeType:(NSString *)mimeTypes progressBlock:(XFUploadProgressBlock)progressBlock successBlock:(XFMultUploadSuccessBlock)successBlock failBlock:(XFMultUploadFailBlock)failBlock {
    
    if (networkStatus == XFNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[YQ_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    NSInteger count = datas.count;
    
    for (int i = 0; i < count; i ++) {
        
        __block XFURLSEssionTask *session = nil;
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:url fileData:datas[i] type:type name:name mimeType:mimeTypes progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
            
            if (progressBlock) progressBlock(bytesWriten,
                                             totalBytes);
            
        } successBlock:^(id response) {
            
            [responses addObject:response];
            
            dispatch_group_leave(uploadGroup);
            
            [sessions removeObject:session];
            
        } failBlock:^(NSError *error) {
            
            NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
            
            [failResponse addObject:Error];
            
            dispatch_group_leave(uploadGroup);
            
            [sessions removeObject:session];
            
        }];
        
        [session resume];
        
        if (session) {
            [sessions addObject:session];
        }
        
    }
    [[self allTasks] addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        
        if (responses.count) {
            if (successBlock) {
                
                successBlock([responses copy]);
                
                if (sessions.count > 0) {
                    
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
    
}

#pragma mark - 下载
+ (XFURLSEssionTask *)downloadWithUrl:(NSString *)url progressBlock:(XFDownloadProgress)progressBlock successBlock:(XFDownloadSuccessBlock)successBlock failBlock:(XFDownloadFailedBlock)failBlock {
    
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block XFURLSEssionTask *session = nil;
    
    NSURL *fileUrl = [[XFCacheManager sharedManager] getDownloadDataFromCacheWithRequestUrl:url];
    
    if (fileUrl) {
        if (successBlock) {
            successBlock(fileUrl);
        }
        return nil;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self sessionmanager];
    
    // 响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            NSData *dataObj = (NSData *)responseObject;
            
            [[XFCacheManager sharedManager] storDownloadData:dataObj requestUrl:url];
            
            NSURL *downFileUrl = [[XFCacheManager sharedManager] getDownloadDataFromCacheWithRequestUrl:url];
            
            successBlock(downFileUrl);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) {
            
            failBlock (error);
            
        }
        
        [self operateResponseCodeWithTask:task responseObj:error url:url authDateout:^{
            
            
            
        } success:^{
            if (failBlock) {
                
                failBlock (nil);
                
            }
            
        }];
        
        
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 处理错误码
+ (void)operateResponseCodeWithTask:(NSURLSessionDataTask *)task responseObj:(NSError *)error url:(NSString *)url authDateout:(void(^)(void))authDateoutBLock success:(void(^)(void))CancelResponseBlock  {
    
    // 获取返回状态码
    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    
    NSData *data = [errResponse dataUsingEncoding:NSUTF8StringEncoding];
    // 获取返回json
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSURLResponse *response = [task response];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    switch ([httpResponse statusCode]) {
            
        case 200:
        {
            // 请求成功
            CancelResponseBlock();
        }
            break;
        case 201:
        {
            // 请求成功
            CancelResponseBlock();
        }
            break;
        case 204:
        {
            // 没有数据
            //            [XFToolManager showProgressInWindowWithString:@""];
            
        }
            break;
        case 400:
        {
            // 请求成功
            if (responseDic) {
                
                [XFToolManager showProgressInWindowWithString:responseDic[@"message"]];
                CancelResponseBlock();
            }
            
        }
            break;
        case 401:
        {
            
            if ([XFUserInfoManager sharedManager].token) {
                
                [self postWithUrl:[XFApiClient pathUrlForLoginWithToken] refreshRequest:YES cache:NO praams:@{@"token":[XFUserInfoManager sharedManager].token} progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
                    
                } successBlock:^(id response) {
                    
                } failBlock:^(NSError *error) {
                    // 授权失败--重新登录
                    [XFToolManager showProgressInWindowWithString:@"登录过期"];
                    
                    XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    
                    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                    
                    [vc presentViewController:navi animated:YES completion:nil];
                }];
            } else {
                
                // 授权失败--重新登录
                [XFToolManager showProgressInWindowWithString:@"请先登录"];
                
                XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                
                UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                
                [vc presentViewController:navi animated:YES completion:nil];
                
            }
            

            
        }
            break;
        case 403:
        {
            // forbidden
            [XFToolManager showProgressInWindowWithString:@"请求失败,请检查网络连接"];
        }
            break;
        case 404:
        {
            // NOT_FOUND
            //            [XFToolManager showProgressInWindowWithString:@"请求失败,请检查网络连接"];
            
            CancelResponseBlock();
            
        }
            break;
        case 500:
        {
            // NOT_FOUND
            [XFToolManager showProgressInWindowWithString:@"请求失败,请检查网络连接"];
            
        }
            break;
            
        default:
        {
//            [XFToolManager showProgressInWindowWithString:@"请求失败,请检查网络连接"];
            
            
        }
            
    }
    
}

+ (void)updateCookieForUrl:(NSURLSessionDataTask *)task {
    
    //获取cookie
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    /*
     * 把cookie进行归档并转换为NSData类型
     * 注意：cookie不能直接转换为NSData类型，否则会引起崩溃。
     * 所以先进行归档处理，再转换为Data
     */
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    
    //存储归档后的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cookiesData forKey:@"cookie"];
    [userDefaults synchronize];
    //取出保存的cookie
}

+ (void)setCookie {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    //对取出的cookie进行反归档处理
    NSArray *cookies1 = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    if (cookies1) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies1) {
            
            [cookieStorage setCookie:cookie];
            
        }
    }else{
        NSLog(@"无cookie");
    }
    
}

+(void)clearCookiesWithUrl:(NSString *)url {
    
    //获取所有cookies
    NSArray*array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
    
    // NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
    
    //删除
    
    for(NSHTTPCookie *cookie in array)
        
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
    
}


#pragma mark - 其他
+ (void)setupTimeout:(NSTimeInterval)timeout {
    
    requestTimeout = timeout;
    
}

+ (void)cancelAllRequest {
    
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(XFURLSEssionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XFURLSEssionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
    
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(XFURLSEssionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XFURLSEssionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}


+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

@end

@implementation XFNetworking (cache)
+ (NSUInteger)totalCacheSize {
    return [[XFCacheManager sharedManager] totalCacheSize];
}

//+ (NSUInteger)totalDownloadDataSize {
//    return [[XFCacheManager sharedManager] ];
//}
//
//+ (void)clearDownloadData {
//    [[XFCacheManager sharedManager] clearDownloadData];
//}
//
//+ (NSString *)getDownDirectoryPath {
//    return [[XFCacheManager sharedManager] getDownDirectoryPath];
//}

+ (NSString *)getCacheDiretoryPath {
    
    return [[XFCacheManager sharedManager] getCacheDiretoryPath];
}

//+ (void)clearTotalCache {
//    [[XFCacheManager sharedManager] clearTotalCache];
//}







@end
