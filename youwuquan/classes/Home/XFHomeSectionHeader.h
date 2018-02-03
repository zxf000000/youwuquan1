//
//  XFHomeSectionHeader.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFHomeSectionHeader;

@protocol XFHomeSectionHeaderDelegate <NSObject>

- (void)homeSectionHeader:(XFHomeSectionHeader *)header didClickButton:(UIButton *)moreButton atSection:(NSInteger )section;

@end

@interface XFHomeSectionHeader : UIView

@property (nonatomic,strong) UIImageView *leftImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,assign) NSInteger section;

@property (nonatomic,strong) id <XFHomeSectionHeaderDelegate> delegate;

@end
