//
//  XFNetWorkManager.m
//  shilitaohua
//
//  Created by mr.zhou on 2017/8/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNetWorkManager.h"
//#import "XFLoginViewController.h"
#import <YYCache.h>

@implementation XFNetWorkManager

+ (instancetype)sharedManager {

    static dispatch_once_t onceToken;
    static XFNetWorkManager *manager = nil;
    dispatch_once(&onceToken, ^{
        
        manager = [[XFNetWorkManager alloc] init];
        
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
    
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else { 
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } 
    return jsonString; 
}

- (void)postWithTokenWithUrl:(NSString *)urlString paraments:(NSMutableDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    self.sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:paraments];
    
    [para setObject:[XFUserInfoManager sharedManager].token forKey:@"token"];
    
    [self.sessionManager POST:urlString parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%zd/%zd",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        dic = [NSDictionary changeType:dic];

        // 判断错误码
        NSDictionary *appbean = dic[@"appBean"];
        
        if ([appbean[@"sign"] intValue] == 666) {
            
            successBlock(appbean);
            
        } else if (dic != nil) {
            
            successBlock(dic);

            
        } else {
            
            [XFToolManager showProgressInWindowWithString:appbean[@"msg"]];
            
            successBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.description);
        
        [XFToolManager showProgressInWindowWithString:@"网络错误"];
        
        failedBlock(error);
    }];
    
//    NSString *str = [self DataTOjsonString:para];
    
//    NSDictionary *finalPara = @{@"req_from":@"mj-app",
//                                @"data":str};
}

- (void)postUrl:(NSString *)urlString paraments:(NSMutableDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    self.sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    [self.sessionManager POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%zd/%zd",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        dic = [NSDictionary changeType:dic];
        
        // 判断错误码
        NSDictionary *appbean = dic[@"appBean"];
        
        if ([appbean[@"sign"] intValue] == 666) {
            
            successBlock(appbean);

        } else {
            
            [XFToolManager showProgressInWindowWithString:appbean[@"msg"]];
            
            successBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [XFToolManager showProgressInWindowWithString:@"网络错误"];

        failedBlock(error);
    }];

}

// 上传数据
- (void)uploadData:(NSData *)data url:(NSString *)url name:(NSString *)name paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    // 拼接token
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:paraments];
    
    [para setObject:[XFUserInfoManager sharedManager].token forKey:@"token"];
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [self.sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        format.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
        
        NSString *fileName = [format stringFromDate:[NSDate date]];
        
        fileName = [fileName stringByAppendingString:@".jpg"];
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        dic = [NSDictionary changeType:dic];

        // 判断错误码
        NSDictionary *appbean = dic[@"appBean"];
        
        if ([appbean[@"sign"] intValue] == 666) {
            
            successBlock(appbean);
            
        } else {
            
            [XFToolManager showProgressInWindowWithString:appbean[@"msg"]];
            
            successBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [XFToolManager showProgressInWindowWithString:@"网络错误"];

        failedBlock(error);
    }];
}

@end
