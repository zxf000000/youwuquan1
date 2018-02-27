//
//  XFHomeDataModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeDataModel.h"

@implementation XFHomeDataModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}// NS_DESIGNATED_INITIALIZER



+ (instancetype)modelWithUserName:(NSString *)name userIcon:(NSString *)userIcon price:(NSString *)price likeNumer:(NSString *)likeNumer isLiked:(NSString *)isLiked userPic:(NSString *)userPic {
    
    return [[self alloc] initWithUserName:name userIcon:userIcon price:price likeNumer:likeNumer isLiked:isLiked userPic:userPic];
    
}

- (instancetype)initWithUserName:(NSString *)name userIcon:(NSString *)userIcon price:(NSString *)price likeNumer:(NSString *)likeNumer isLiked:(NSString *)isLiked userPic:(NSString *)userPic {
    
    if (self = [super init]) {
        
        _nickname = name;
        _userIcon = userIcon;
        _userPic = userPic;
        _price = price;
        _likeNumer = likeNumer;
        _isLiked = isLiked;
        
    }
    return self;
}


@end
