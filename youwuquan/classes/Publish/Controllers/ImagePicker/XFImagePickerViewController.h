//
//  XFImagePickerViewController.h
//  chaofen
//
//  Created by mr.zhou on 2017/8/8.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"
@class XFImagePickerViewController;


@protocol XFImagePickerDelegate <NSObject>

- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images;

@end

@interface XFImagePickerViewController : XFOtherMainViewController

@property (nonatomic,strong) id <XFImagePickerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *selectedImages;

@property (nonatomic,assign) NSInteger selectedNumber;


@property (nonatomic,assign) BOOL isCircle;

@property (nonatomic,strong) MBProgressHUD *HUD;



@end
