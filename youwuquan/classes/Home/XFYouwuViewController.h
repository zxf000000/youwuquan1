//
//  XFYouwuViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XFYouwuVCType) {
  
    Nethot,
    Youwu,
    
};

@interface headerView : UICollectionReusableView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *headCollectionView;

@property (nonatomic,copy) NSArray *models;
@property (nonatomic,assign) XFYouwuVCType type;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,copy) void(^headerShouldPushVC)(UIViewController *vc);

@end

@interface XFYouwuViewController : UIViewController

@property (nonatomic,assign) XFYouwuVCType type;

- (void)loadData;

@end
