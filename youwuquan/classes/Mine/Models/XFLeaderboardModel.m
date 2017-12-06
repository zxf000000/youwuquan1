//
//  XFLeaderboardModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLeaderboardModel.h"

@implementation XFLeaderboardModel

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name number:(NSString *)number {
    
    if (self = [super init]) {
        
        _icon = icon;
        _name = name;
        _number = number;
    }
    return self;
}

@end
