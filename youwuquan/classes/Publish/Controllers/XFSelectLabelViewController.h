//
//  XFSelectLabelViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMainViewController.h"
#import "XFOtherMainViewController.h"

@class XFSelectLabelViewController;

@protocol XFSelectTagVCDelegate <NSObject>

- (void)selecteTagVC:(XFSelectLabelViewController *)selecteVC didSelectedTagsWith:(NSArray *)tags;

@end

@interface XFSelectLabelViewController : XFOtherMainViewController

@property (nonatomic,strong) NSMutableArray *labelsArr;

@property (nonatomic,strong) id <XFSelectTagVCDelegate> delegate;

@end
