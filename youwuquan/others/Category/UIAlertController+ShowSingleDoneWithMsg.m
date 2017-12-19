//
//  UIAlertController+ShowSingleDoneWithMsg.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "UIAlertController+ShowSingleDoneWithMsg.h"

@implementation UIAlertController (ShowSingleDoneWithMsg)

+ (instancetype)xfalertControllerWithMsg:(NSString *)msg doneBlock:(void(^)(void))doneHandle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
       
        doneHandle();
        
    }];
    
    [alert addAction:actionDone];
    
    return alert;
}

@end
