//
//  XFMyStatusViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"
#import "XFStatusModel.h"

typedef NS_ENUM(NSInteger,XFMyStatuVCType) {
  
    XFMyStatuVCTypeMine,
    XFMyStatuVCTypeOther,
    
};

@interface XFMyStatusCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *picView;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,copy) NSString *url;

@end

@interface XFMyStatusViewController : XFOtherMainViewController

@property (nonatomic,assign) XFMyStatuVCType type;


@property (nonatomic,strong) XFStatusModel *model;



@end
