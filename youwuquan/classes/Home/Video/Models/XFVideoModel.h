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
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSDictionary *video;
@property (nonatomic,copy) NSString *viewNum;

@end
