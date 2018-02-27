//
//  XFVideoModel.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/12.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFVideoModel : NSObject

@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSDictionary *coverImage;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSDictionary *user;
@property (nonatomic,copy) NSDictionary *video;
@property (nonatomic,copy) NSString *viewNum;
@property (nonatomic,copy) NSString *receivedDiamonds;
@property (nonatomic,copy) NSString *diamonds;


@end
