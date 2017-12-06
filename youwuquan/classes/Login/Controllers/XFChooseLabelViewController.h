//
//  XFChooseLabelViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFChooseLabelcell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@end

@interface XFChooseLabelViewController : UIViewController
@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *birthday;

@property (nonatomic,copy) NSArray *tags;

@end
