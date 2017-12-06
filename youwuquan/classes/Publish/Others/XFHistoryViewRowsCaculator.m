//
//  XFHistoryViewRowsCaculator.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/7.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFHistoryViewRowsCaculator.h"

@implementation XFHistoryViewRowsCaculator

+ (NSInteger)numbersOfRowWithArr:(NSArray *)titleArr {

    CGFloat totalWidth = 20;
    
    for (NSInteger i = 0 ; i < titleArr.count ; i ++ ) {
    
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
        
        NSString *str = [NSString stringWithFormat:@"#%@#",titleArr[i]];
        
        CGSize size=[str sizeWithAttributes:attrs];
        
        CGFloat width = size.width + 20;
        // 计算总长度
        
        if ((NSInteger)kScreenWidth - (NSInteger)totalWidth%(NSInteger)kScreenWidth >= width + 5 + 5){
            
            totalWidth += (width + 5);

        } else {
            
            totalWidth += (width + 5) + ((NSInteger)kScreenWidth - (NSInteger)totalWidth%(NSInteger)kScreenWidth);
            
        }
        
    }
    // 除以屏幕宽度,取整数+1行为总行数
    NSInteger rows = (NSInteger)totalWidth/kScreenWidth;

    rows += 1;

    return rows;
}

@end
