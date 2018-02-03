//
//  XFDanmuModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <HJDanmakuModel.h>

@interface XFDanmuModel : HJDanmakuModel

@property (nonatomic, assign) BOOL selfFlag;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, strong) UIFont   *textFont;

@end
