//
//  XFStatusModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XFStatusModel : NSObject

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,copy) NSString *customLabel;

@property (nonatomic,copy) NSString *greatNum;

@property (nonatomic,copy) NSString *headUrl;

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSArray *imageList;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSArray *intimateImageList;

@property (nonatomic,copy) NSString *inviteMoney;

@property (nonatomic,copy) NSString *labelNames;

@property (nonatomic,copy) NSString *messageNum;

@property (nonatomic,copy) NSArray *openImageList;

@property (nonatomic,copy) NSArray *roleList;

@property (nonatomic,copy) NSString *state;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *unlockNum;

@property (nonatomic,copy) NSString *unlockUserNo;

@property (nonatomic,copy) NSString *userNike;

@property (nonatomic,copy) NSString *userNo;

@property (nonatomic,copy) NSArray *videoUrlList;
@property (nonatomic,copy) NSArray *coverImage;

@property (nonatomic,copy) NSString *isCared;

@property (nonatomic,copy) NSString *isLiked;



+ (instancetype)modelWithName:(NSString *)userName icon:(NSString *)userIcon images:(NSArray *)images contents:(NSString *)contents isCares:(NSString *)isCared time:(NSString *)time isLiked:(NSString *)isLiked likeNumber:(NSString *)likeNumber commentNumber:(NSString *)commentNumber;

@end
