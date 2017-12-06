//
//  XFLeaderboardModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFLeaderboardModel : NSObject

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *number;

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name number:(NSString *)number;

@end
