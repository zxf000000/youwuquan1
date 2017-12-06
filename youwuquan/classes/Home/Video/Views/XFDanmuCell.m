//
//  XFDanmuCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDanmuCell.h"

@implementation XFDanmuCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.layer.borderWidth = 0;
}


@end
