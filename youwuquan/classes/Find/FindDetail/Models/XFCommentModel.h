//
//  XFCommentModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCommentModel : NSObject

@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *parentHeadUrl;
@property (nonatomic,copy) NSString *parentUserNike;
@property (nonatomic,copy) NSString *parentUserNo;
@property (nonatomic,copy) NSString *readFlag;
@property (nonatomic,copy) NSString *releaseId;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *userNike;
@property (nonatomic,copy) NSString *userNoA;
@property (nonatomic,copy) NSString *userNoB;

@end
