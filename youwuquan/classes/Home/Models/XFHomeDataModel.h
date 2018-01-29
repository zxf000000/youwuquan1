//
//  XFHomeDataModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFHomeDataModel : NSObject <NSCoding>

@property (nonatomic,copy) NSDictionary *coverImage;
@property (nonatomic,copy) NSString *coverImageUrl;

@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSArray *identifications;
@property (nonatomic,copy) NSString *likeNum;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *uid;


@property (nonatomic,copy) NSString *userIcon;

@property (nonatomic,copy) NSString *price;

@property (nonatomic,copy) NSString *likeNumer;

@property (nonatomic,copy) NSString *isLiked;

@property (nonatomic,copy) NSString *userPic;

@property (nonatomic,assign) BOOL likeIt;


+ (instancetype)modelWithUserName:(NSString *)name userIcon:(NSString *)userIcon price:(NSString *)price likeNumer:(NSString *)likeNumer isLiked:(NSString *)isLiked userPic:(NSString *)userPic;

@end
