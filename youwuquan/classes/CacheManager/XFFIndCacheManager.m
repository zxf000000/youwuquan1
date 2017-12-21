//
//  XFFIndCacheManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFIndCacheManager.h"
#import "XFStatusModel.h"

@implementation XFFIndCacheManager

+ (instancetype)sharedManager {
    static XFFIndCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XFFIndCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _findCache = [[YYCache alloc] initWithName:@"findCache"];
        _inviteCache = [[YYCache alloc] initWithName:@"inviteCache"];

        
    }
    return self;
}

- (NSArray *)arrFrom:(NSInteger)index count:(NSInteger)count {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = index ; i < count + index ; i ++) {
        
        [arr addObject:[NSString stringWithFormat:@"find%zd",i]];
        
    }
    
    return arr.copy;
    
}

- (NSArray *)findData {
    
    NSArray *array = @[[XFStatusModel modelWithName:@"小灰猫" icon:@"icon1" images:[self arrFrom:10 count:1] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:YES],
                       [XFStatusModel modelWithName:@"小黄猫" icon:@"icon2" images:[self arrFrom:1 count:2] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小白猫" icon:@"icon3" images:[self arrFrom:3 count:3] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小栏猫" icon:@"icon4" images:[self arrFrom:6 count:4] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小子猫" icon:@"icon5" images:[self arrFrom:10 count:5] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小宏猫" icon:@"icon6" images:[self arrFrom:15 count:6] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小住猫" icon:@"icon7" images:[self arrFrom:21 count:7] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小够猫" icon:@"icon8" images:[self arrFrom:28 count:8] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小狼猫" icon:@"icon9" images:[self arrFrom:10 count:9] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小大象猫" icon:@"icon10" images:[self arrFrom:9 count:8] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小到猫" icon:@"icon11" images:[self arrFrom:17 count:7] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小灰猫" icon:@"icon12" images:[self arrFrom:24 count:6] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小灰猫" icon:@"icon13" images:[self arrFrom:30 count:5] contents:@"" isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],];

    return array;
    
}

- (NSArray *)searchData {
    
    if (_searchData == nil) {
    
    NSArray *array = @[[XFStatusModel modelWithName:@"小灰猫" icon:@"icon14" images:[self arrFrom:1 count:1] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小黄猫" icon:@"icon15" images:[self arrFrom:2 count:2] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小白猫" icon:@"icon16" images:[self arrFrom:4 count:3] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小栏猫" icon:@"icon1" images:[self arrFrom:7 count:4] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小子猫" icon:@"icon2" images:[self arrFrom:11 count:5] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小宏猫" icon:@"icon3" images:[self arrFrom:16 count:6] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小住猫" icon:@"icon4" images:[self arrFrom:22 count:7] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小够猫" icon:@"icon8" images:[self arrFrom:29 count:8] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小狼猫" icon:@"icon9" images:[self arrFrom:11 count:9] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小大象猫" icon:@"icon10" images:[self arrFrom:10 count:8] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小到猫" icon:@"icon11" images:[self arrFrom:21 count:7] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小灰猫" icon:@"icon12" images:[self arrFrom:29 count:6] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],
                       [XFStatusModel modelWithName:@"小灰猫" icon:@"icon13" images:[self arrFrom:30 count:5] contents:kRandomComment isCares:@"0" time:@"2018-09-12 12:23:43" isLiked:@"1" likeNumber:@"110" commentNumber:@"120" isVideo:NO],];
    
        _searchData = array;
    }
    return _searchData;
    
}

@end
