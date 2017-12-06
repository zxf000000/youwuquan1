//
//  XFfindCellLayout.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kIconTopSpace 17 // 顶部灰色
#define kTopSpace 10 //头部上放
#define KiconHeight 45  // 头像高度
#define kIconBottomSpace  18
#define kPicWidth   (kScreenWidth - 20)
#define kPicHeight  kPicWidth * 19/35.f

#define kRewardButtonHeight 20  // 打赏按钮
#define kRewardButtonBottom 15
#define kTextTopSpace 15 // 文字上方
#define kTextHeight 48  // 三行文字高度

#define kTextBottomSpace 34

#define kMoreHeight 20
#define kLineTop 20
#define kLineHeight 1
#define kTimeTop 17
#define kTimeBottom 17
#define kTimeHeight 16

@interface XFfindCellLayout : NSObject

+ (CGFloat)caculateHeightForCell;

+ (CGFloat)caculateHeightForCellWithText:(NSString *)text;

@end
