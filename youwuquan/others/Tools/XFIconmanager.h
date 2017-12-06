//
//  XFIconmanager.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFIconmanager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,copy)  NSArray *authIcons;

@property (nonatomic,copy) NSArray *homeImages;

@property (nonatomic,copy) NSArray *findImages;

@property (nonatomic,copy) NSArray *hdIimages;

@property (nonatomic,copy) NSArray *headImages;

@property (nonatomic,copy) NSArray *videoPics;

@property (nonatomic,copy) NSArray *comments;

@property (nonatomic,copy) NSArray *names;

@property (nonatomic,copy) NSArray *pingluns;

@end
