//
//  XFMissionModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMissionModel.h"

@implementation XFMissionModel

- (instancetype)initWithCoin:(NSString *)coin number:(NSString *)number total:(NSString *)total title:(NSString *)title detail:(NSString *)detail {
    
    if (self = [super init]) {
        
        _coin = coin;
        _number = number;
        _total = total;
        _title = title;
        _detail = detail;
        
    }
    return self;
}

+ (NSArray *)missionModels {
    
    XFMissionModel *model1 = [[XFMissionModel alloc] initWithCoin:@"50" number:@"2" total:@"5" title:@"分享内容" detail:@"做人不能只自己享受，好内容当然要分享给朋友"];
    XFMissionModel *model2 = [[XFMissionModel alloc] initWithCoin:@"50" number:@"2" total:@"5" title:@"每日签到" detail:@"精彩的日子少不了尤物圈，尤物圈天天等你"];
    XFMissionModel *model3 = [[XFMissionModel alloc] initWithCoin:@"50" number:@"2" total:@"5" title:@"热心评论" detail:@"您对内容的点评是我们误伤的喜悦"];
    XFMissionModel *model4 = [[XFMissionModel alloc] initWithCoin:@"50" number:@"5" total:@"5" title:@"精彩点赞" detail:@"热心评论"];
    XFMissionModel *model5 = [[XFMissionModel alloc] initWithCoin:@"50" number:@"2" total:@"5" title:@"新人福利" detail:@"我们为每一位新人都准备了一份豪礼哦"];
    
    return @[model1,model2,model3,model4,model5];
}

@end
