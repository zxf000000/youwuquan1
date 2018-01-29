//
//  XFAddImageViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"


@interface XFPublishVideoViewController : XFOtherMainViewController <UINavigationControllerDelegate>

@property (nonatomic,strong) UIImage *videoImage;

@property (nonatomic,assign) BOOL isOpenVideo;

@property (nonatomic,copy) NSString *videoPath;

@property (nonatomic,assign) NSInteger videoWidth;
@property (nonatomic,assign) NSInteger videoHeight;


@end
