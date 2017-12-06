//
//  XFfindCellLayout.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFfindCellLayout.h"

@implementation XFfindCellLayout

+ (CGFloat)caculateHeightForCellWithText:(NSString *)text {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 2. 为文本设置属性
    str.font = [UIFont systemFontOfSize:13];
    str.color = [UIColor blackColor];
    str.lineSpacing = 3;
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
    
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:str];
    
    CGSize textSize = layout.textBoundingSize;
    
    return kTopSpace + kIconTopSpace + KiconHeight + kIconBottomSpace + kPicHeight + kRewardButtonHeight+ kRewardButtonBottom + kTextTopSpace + textSize.height + kMoreHeight + kLineTop + kLineHeight + kTimeTop + kTimeBottom + kTimeHeight;
}

+ (CGFloat)caculateHeightForCell {
    
    return kTopSpace + kIconTopSpace + KiconHeight + kIconBottomSpace + kPicHeight + kRewardButtonHeight + kRewardButtonBottom + kTextTopSpace + kTextHeight + kMoreHeight + kLineTop + kLineHeight + kTimeTop + kTimeBottom + kTimeHeight;
    
}

@end
