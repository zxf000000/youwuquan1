//
//  XFMissionModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMissionModel : NSObject

@property (nonatomic,copy) NSDictionary *category;

@property (nonatomic,copy) NSString *currentProgress;

@property (nonatomic,copy) NSString *day;

@property (nonatomic,copy) NSString *totalProgress;

@property (nonatomic,copy) NSString *updateTime;

@property (nonatomic,copy) NSString *detail;

- (instancetype)initWithCoin:(NSString *)coin number:(NSString *)number total:(NSString *)total title:(NSString *)title detail:(NSString *)detail;

+ (NSArray *)missionModels;
@end
