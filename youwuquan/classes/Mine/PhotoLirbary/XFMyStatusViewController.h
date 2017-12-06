//
//  XFMyStatusViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFMyStatusCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *picView;

@end

@interface XFMyStatusViewController : XFOtherMainViewController

@end
