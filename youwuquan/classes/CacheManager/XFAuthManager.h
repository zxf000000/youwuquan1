//
//  XFAuthManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/12.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFMyAuthViewController.h"

@interface XFAuthManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,copy) NSArray *authList;

@property (nonatomic,copy) NSArray *icons;

@property (nonatomic,copy) NSArray *ids;

@end
