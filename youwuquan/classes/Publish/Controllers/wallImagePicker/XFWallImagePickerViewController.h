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

typedef NS_ENUM(NSInteger,XFImagePickerType) {
  
    XFImagePickerTypeImage,
    XFImagePickerTypeVideo,
    
};

@protocol XFWallImagePickerDelegate <NSObject>

- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images;

@end

@interface XFWallImagePickerViewController : XFOtherMainViewController

@property (nonatomic,strong) id <XFWallImagePickerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *selectedImages;

@property (nonatomic,assign) NSInteger selectedNumber;

@property (nonatomic,assign) XFImagePickerType type;


@property (nonatomic,assign) BOOL isCircle;

@property (nonatomic,strong) MBProgressHUD *HUD;



@end
