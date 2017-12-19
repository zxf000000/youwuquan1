//
//  XFmyPhotoModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFStatusModel.h"

@interface XFmyPhotoModel : NSObject

@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,copy) NSString *breviaryUrl;

@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *imgHeight;
@property (nonatomic,copy) NSString *imgWidth;

@property (nonatomic,strong) XFStatusModel *status;

@property (nonatomic,copy) NSString *releaseId;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *userNo;

@property (nonatomic,copy) NSString *vagueUrl;


@end
