//
//  XFAddressModel.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/25.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFAddressModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *postcode;
@property (nonatomic,copy) NSString *phone;


@end
