//
//  XFNetworking+RequestManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNetworking+RequestManager.h"

@interface NSURLRequest (decide)

- (BOOL)isTheSameRequest:(NSURLRequest *)request;

@end

@implementation NSURLRequest (decide)


- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            
            if ([self.HTTPMethod isEqualToString:@"GET"] || [self.HTTPBody isEqualToData:request.HTTPBody]) {
                
                return YES;
                
            }
            
        }
        
    }
    
    return NO;
    
}

@end

@implementation XFNetworking (RequestManager)

+ (BOOL)haveSameRequestInTasksPool:(XFURLSEssionTask *)task {
    
    __block BOOL isSame = NO;
    
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(XFURLSEssionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            
            isSame = YES;
            *stop = YES;
            
        }
    }];
    
    return isSame;
}


+ (XFURLSEssionTask *)cancelSameRequestTasksPool:(XFURLSEssionTask *)task {
    
    __block XFURLSEssionTask *oldTask = nil;
    
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(XFURLSEssionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([[task currentRequest] isTheSameRequest:obj.originalRequest]) {
            
            if (obj.state == NSURLSessionTaskStateRunning) {
                [obj cancel];
                oldTask = obj;
            }
            *stop = YES;
        }
        
    }];
    return oldTask;
}

@end
