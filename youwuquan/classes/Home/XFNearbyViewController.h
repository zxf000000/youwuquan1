//
//  XFNearbyViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NearbyVCType) {
    
    Nearby,
    SearchMan,
    
};

@interface XFNearbyViewController : UIViewController

@property (nonatomic,assign) NearbyVCType type;


@end
