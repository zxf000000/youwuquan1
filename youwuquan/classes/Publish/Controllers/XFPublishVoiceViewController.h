//
//  XFPublishVoiceViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/19.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"
#import "XFAddImageViewController.h"

@interface XFPublishVoiceViewController : XFOtherMainViewController <UINavigationControllerDelegate>

@property (nonatomic,assign) XFAddImgVCType type;

@property (nonatomic,strong) UIImage *videoImage;

@property (nonatomic,assign) BOOL isOpenVideo;

@property (nonatomic,copy) NSString *videoPath;

@property (nonatomic,copy) NSString *recordingFilePath;

@property (nonatomic,assign) NSInteger totalSeconds;


@end
