//
//  XFImageSizeCache.m
//  huishangPlus
//
//  Created by mr.zhou on 2017/10/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFImageSizeCache.h"

@implementation XFImageSizeCache

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    static XFImageSizeCache *cache = nil;
    dispatch_once(&onceToken, ^{
        
        cache = [[XFImageSizeCache alloc] init];

    });
    return cache;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _imageCache = [NSMutableDictionary dictionary];
        
    }
    return self;
}

@end
