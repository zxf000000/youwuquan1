//
//  XFGiftManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/10.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFGiftModel : NSObject

@property (nonatomic,copy) NSString *diamonds;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sortId;

@end

@interface XFGiftManager : NSObject

@property (nonatomic,strong) YYCache *giftCache;

@property (nonatomic,strong) NSArray *gift;

@end
