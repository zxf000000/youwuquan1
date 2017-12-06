//
//  XFPublishVCTransation.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XFPresenttransationType) {
    
    Present,
    Dismiss,
    Push,
    Pop,
    
};

@interface XFPublishTransation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithtype:(XFPresenttransationType)type;

- (instancetype)initWithType:(XFPresenttransationType)type;

@property (nonatomic,assign) XFPresenttransationType type;


@end
