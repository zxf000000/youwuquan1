//
//  XFSearchViewController.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/11.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMainViewController.h"

@interface XFSearchDeleteHeader : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,copy) void (^clickDeleteButtonBlock)(void);

@end

@interface XFSearchHeader : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@end

@interface XFSearchViewController : XFMainViewController

@property (nonatomic,copy) void(^backBlock)();

@end
