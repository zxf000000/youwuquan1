//
//  XFImageSizeCache.h
//  huishangPlus
//
//  Created by mr.zhou on 2017/10/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFImageSizeCache : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) NSMutableDictionary *imageCache;

@end
