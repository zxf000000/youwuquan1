//
//  XFSkillModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFSkillModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *skillIcon;
@property (nonatomic,copy) NSString *skillName;
@property (nonatomic,copy) NSString *skillNo;


@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL status;

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name status:(BOOL )status;

@end
