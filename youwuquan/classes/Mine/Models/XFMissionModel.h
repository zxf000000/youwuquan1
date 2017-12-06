//
//  XFMissionModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMissionModel : NSObject

@property (nonatomic,copy) NSString *coin;

@property (nonatomic,copy) NSString *number;

@property (nonatomic,copy) NSString *total;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *detail;

- (instancetype)initWithCoin:(NSString *)coin number:(NSString *)number total:(NSString *)total title:(NSString *)title detail:(NSString *)detail;

+ (NSArray *)missionModels;
@end
