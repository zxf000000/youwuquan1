//
//  XFStatusModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusModel.h"

@implementation XFStatusModel

+ (instancetype)modelWithName:(NSString *)userName icon:(NSString *)userIcon images:(NSArray *)images contents:(NSString *)contents isCares:(NSString *)isCared time:(NSString *)time isLiked:(NSString *)isLiked likeNumber:(NSString *)likeNumber commentNumber:(NSString *)commentNumber {
    
    return [[self alloc] initWithName:userName icon:userIcon images:images contents:contents isCares:isCared time:time isLiked:isLiked likeNumber:likeNumber commentNumber:commentNumber];
}

- (instancetype)initWithName:(NSString *)userName icon:(NSString *)userIcon images:(NSArray *)images contents:(NSString *)contents isCares:(NSString *)isCared time:(NSString *)time isLiked:(NSString *)isLiked likeNumber:(NSString *)likeNumber commentNumber:(NSString *)commentNumber {
    
    if (self = [super init]) {
        
        _userNike = userName;
        _headUrl = userIcon;
        _imageList = images;
        _title = contents;
        _isCared = isCared;
        _isLiked = isLiked;
        _createTime = time;
        _greatNum = likeNumber;
        _messageNum = commentNumber;
        
    }
    return self;
}

@end
