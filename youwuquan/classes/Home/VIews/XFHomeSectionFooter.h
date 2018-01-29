//
//  XFHomeSectionFooter.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFHomeSectionFooter : UIView

@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,strong) UIImageView *shadowImage;

@property (nonatomic,assign) NSInteger section;

@property (nonatomic,copy) void(^clickMoreButtonForSection)(NSInteger section);


@end
