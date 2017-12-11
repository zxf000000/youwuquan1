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

    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];

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
    
    NSDictionary *dic = paraments;
    
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
    
    [self.sessionManager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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


// 发布上传数据
- (void)publishUploadWithUrl:(NSString *)url Opens:(NSArray *)opens secs:(NSArray *)secs paraments:(NSDictionary *)paraments successHandle:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    
    // 拼接token
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:paraments];
    
    [para setObject:[XFUserInfoManager sharedManager].token forKey:@"token"];
    [para setObject:[XFUserInfoManager sharedManager].userName forKey:@"userNo"];
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                     @"text/html",
                                                                     @"image/jpeg",
                                                                     @"image/png",
                                                                     @"application/octet-stream",
                                                                     @"text/json",
                                                                     nil];
    
    [self.sessionManager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < opens.count; i++) {
            
            UIImage *image = opens[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%zd.jpg",dateString,i];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"opens" fileName:fileName mimeType:@"image/jpeg"];
        }
        
        for (int i = 0; i < secs.count; i++) {
            
            UIImage *image = secs[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%zd.jpg",dateString,i];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"intimates" fileName:fileName mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%zd",uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        dic = [NSDictionary changeType:dic];
        
        
        if (dic[@"success"]) {
            
            successBlock(dic);
            
            return;
        }
        
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
