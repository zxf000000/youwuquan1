//
//  UIAlertController+ShowSingleDoneWithMsg.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ShowSingleDoneWithMsg)

+ (instancetype)xfalertControllerWithMsg:(NSString *)msg doneBlock:(void(^)(void))doneHandle;

@end
