//
//  XFNearModel.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/17.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFNearModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString *identifications;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *uid;

@end
