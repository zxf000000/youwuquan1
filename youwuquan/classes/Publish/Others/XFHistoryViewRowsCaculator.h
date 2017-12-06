//
//  XFHistoryViewRowsCaculator.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/7.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFHistoryViewRowsCaculator : NSObject

@property (nonatomic,copy) NSArray *titleArr;

+ (NSInteger)numbersOfRowWithArr:(NSArray *)titleArr;


@end
