//
//  XFSkillModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSkillModel.h"

@implementation XFSkillModel

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name status:(BOOL )status {
    
    if (self = [super init]) {
        
        _icon = icon;
        _name = name;
        _status = status;
    }
    return self;
}

@end
