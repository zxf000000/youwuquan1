//
//  XFStatusModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFStatusModel : NSObject

@property (nonatomic,copy) NSString *receivedDiamonds;

@property (nonatomic,copy) NSString *commentNum;

@property (nonatomic,copy) NSDictionary *coverPictureUrl;

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSArray *labels;

@property (nonatomic,copy) NSString *likeNum;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSArray *pictures;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *viewNum;

@property (nonatomic,copy) NSString *state;

@property (nonatomic,copy) NSDictionary *user;

// coverUrl---id---srcUrl
@property (nonatomic,copy) NSDictionary *video;

@property (nonatomic,copy) NSArray *comments;

@property (nonatomic,copy) NSArray *likeUsers;

@property (nonatomic,assign) BOOL likedIt;

@property (nonatomic,copy) NSString *unlockPrice;

@property (nonatomic,copy) NSDictionary *audio;

//@property (nonatomic,copy) NSString *title;
//
//@property (nonatomic,copy) NSString *type;
//
//@property (nonatomic,copy) NSString *unlockNum;
//
//@property (nonatomic,copy) NSString *unlockUserNo;
//
//@property (nonatomic,copy) NSString *userNike;
//
//@property (nonatomic,copy) NSString *userNo;
//
//@property (nonatomic,copy) NSArray *videoUrlList;
//@property (nonatomic,copy) NSArray *coverImage;
//
//@property (nonatomic,copy) NSString *isCared;
//
//@property (nonatomic,copy) NSString *isLiked;
//
//@property (nonatomic,assign) BOOL isVideo;

+ (instancetype)modelWithName:(NSString *)userName icon:(NSString *)userIcon images:(NSArray *)images contents:(NSString *)contents isCares:(NSString *)isCared time:(NSString *)time isLiked:(NSString *)isLiked likeNumber:(NSString *)likeNumber commentNumber:(NSString *)commentNumber isVideo:(BOOL)isVideo;

@end
