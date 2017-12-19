//
//  XFHomeCacheManger.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeCacheManger.h"
#import "XFHomeDataModel.h"

@implementation XFHomeCacheManger

+ (instancetype)sharedManager {
    static XFHomeCacheManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XFHomeCacheManger alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _homeCache = [[YYCache alloc] initWithName:@"homeData"];
        _ywCache = [[YYCache alloc] initWithName:@"yanyuancache"];
        _whCache = [[YYCache alloc] initWithName:@"wanghongcache"];
        _videoCache = [[YYCache alloc] initWithName:@"videocache"];

    }
    return self;
}

- (NSArray *)homeData {
    
    NSArray *arr1 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon1" price:@"120" likeNumer:@"220" isLiked:@"0" userPic:@"home1"],
                      [XFHomeDataModel modelWithUserName:@"王心凌" userIcon:@"icon2" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home2"]];
    NSArray *arr2 = @[[XFHomeDataModel modelWithUserName:@"世界只因有你" userIcon:@"icon3" price:@"160" likeNumer:@"220" isLiked:@"0" userPic:@"home3"],
                      [XFHomeDataModel modelWithUserName:@"仅有的自私" userIcon:@"icon4" price:@"320" likeNumer:@"200" isLiked:@"0" userPic:@"home4"]];
    NSArray *arr3 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon5" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home5"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon6" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home6"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon7" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home7"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon8" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home8"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon9" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home9"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon10" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home10"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon11" price:@"1000" likeNumer:@"900" isLiked:@"0" userPic:@"home11"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon12" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home12"]];
    NSArray *arr4 = @[[XFHomeDataModel modelWithUserName:@"曲漾" userIcon:@"icon13" price:@"160" likeNumer:@"220" isLiked:@"0" userPic:@"home13"],
                      [XFHomeDataModel modelWithUserName:@"土匪i" userIcon:@"icon14" price:@"320" likeNumer:@"200" isLiked:@"0" userPic:@"home14"]];

    
    return @[arr1,arr2,arr3,arr4];
}

- (NSArray *)ywData {
    
    NSArray *arr1 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon15" price:@"120" likeNumer:@"220" isLiked:@"0" userPic:@"home15"],
                      [XFHomeDataModel modelWithUserName:@"王心凌" userIcon:@"icon16" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home16"]];

    NSArray *arr3 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon2" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home19"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon3" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home20"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon4" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home21"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon5" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home22"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon6" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home23"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon7" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home24"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon8" price:@"1000" likeNumer:@"900" isLiked:@"0" userPic:@"home25"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon9" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home26"]];

    
    
    return @[arr1,arr3];
}

- (NSArray *)whData {
    
    NSArray *arr1 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon12" price:@"120" likeNumer:@"220" isLiked:@"0" userPic:@"home29"],
                      [XFHomeDataModel modelWithUserName:@"王心凌" userIcon:@"icon13" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home30"]];

    NSArray *arr3 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon16" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home33"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon1" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home34"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon2" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home35"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon3" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home36"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon4" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home1"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon5" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home2"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon6" price:@"1000" likeNumer:@"900" isLiked:@"0" userPic:@"home3"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon7" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home4"]];

    
    
    return @[arr1,arr3];
}

- (NSArray *)videoData {
    

    NSArray *arr1 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon5" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home19"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon6" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home20"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon7" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home21"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon8" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home22"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon9" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home23"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon10" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home24"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon11" price:@"1000" likeNumer:@"900" isLiked:@"0" userPic:@"home25"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon12" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home26"]];
    NSArray *arr3 = @[[XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon14" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home11"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon15" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home12"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon16" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home13"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon17" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home14"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon1" price:@"10000" likeNumer:@"900" isLiked:@"0" userPic:@"home15"],
                      [XFHomeDataModel modelWithUserName:@"媛若惜" userIcon:@"icon2" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home16"],
                      [XFHomeDataModel modelWithUserName:@"周杰伦" userIcon:@"icon3" price:@"1000" likeNumer:@"900" isLiked:@"0" userPic:@"home17"],
                      [XFHomeDataModel modelWithUserName:@"欠削" userIcon:@"icon4" price:@"320" likeNumer:@"240" isLiked:@"1" userPic:@"home18"]];

    
    
    return @[arr1,arr3];
}

- (void)removeAllData {
    
    [_homeCache removeAllObjects];
    
    
}

@end
