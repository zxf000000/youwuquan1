//
//  XFCardSizeCache.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCardSizeCache : NSObject


+ (instancetype)sharedInstance;

@property (nonatomic,copy) NSArray *cardSizeCache;

@property (nonatomic,copy) NSArray *threeSize;
@property (nonatomic,copy) NSArray *fourSize;
@property (nonatomic,copy) NSArray *fiveSize;
@property (nonatomic,copy) NSArray *sixSize;
@property (nonatomic,copy) NSArray *sevenSize;
@property (nonatomic,copy) NSArray *eightSize;



@end
