//
//  XFMessageCacheManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/13.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSystemMessageCache @"systemMessageCache"
#define KLikeCommentsMessageCache @"likeCommentMessageCache"
#define kOtherMessageCache @"OtherMessageCache"

@interface XFMessageCacheManager : NSObject

@property (nonatomic,strong) YYCache *msgCache;

@property (nonatomic,copy) NSArray *systemMessageCache;
@property (nonatomic,copy) NSArray *otherMessageCache;
@property (nonatomic,copy) NSArray *likeCommentCache;

+ (instancetype)sharedManager;

- (void)updateCacheWith:(NSDictionary *)info;

- (void)updateSystemMessageCacheWith:(NSArray *)systemMessageCache;
- (void)updateLikeCommentsMessageCacheWith:(NSArray *)likeCOmments;
- (void)updateOtherMessageWith:(NSArray *)othermessage;

@end
