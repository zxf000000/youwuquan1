//
//  XFMyVideoStatusViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/9.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XFPLSActionType) {
    XFPLSActionTypePlayer = 0,
    XFPLSActionTypeGif,
};

@interface XFMyVideoStatusViewController : UIViewController

@property (assign, nonatomic) XFPLSActionType actionType;
@property (strong, nonatomic) NSURL *url;

@property (nonatomic,copy) void(^uploadSuccessBlock)(UIImage *image, NSString *videoUrl);


@end
