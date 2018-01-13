//
//  XFCommentModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCommentModel : NSObject

@property (nonatomic,copy) NSString *publishId;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSString *childComments;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *commentDate;
//@property (nonatomic,copy) NSString *releaseId;
//@property (nonatomic,copy) NSString *type;
//
//@property (nonatomic,copy) NSString *userNike;
//@property (nonatomic,copy) NSString *userNoA;
//@property (nonatomic,copy) NSString *userNoB;

@end
