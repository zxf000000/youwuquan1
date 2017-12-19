//
//  XFAddImageViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

typedef NS_ENUM(NSInteger,XFAddImgVCType) {
    
    XFAddImgVCTypeImg,
    XFAddImgVCTypeVideo,
    
};

@interface XFAddImageViewController : XFOtherMainViewController <UINavigationControllerDelegate>

@property (nonatomic,assign) XFAddImgVCType type;

@property (nonatomic,strong) UIImage *videoImage;

@property (nonatomic,assign) BOOL isOpenVideo;

@property (nonatomic,copy) NSString *videoPath;

@end
