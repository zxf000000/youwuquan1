//
//  XFTabBar.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTabBar.h"

@implementation XFTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *plusButton = [[UIButton alloc] init];
        
        [plusButton setImage:[UIImage imageNamed:@"tabbar_publish"] forState:(UIControlStateNormal)];
        
        [plusButton setTitle:@"发布" forState:(UIControlStateNormal)];
        [plusButton setTitleColor:UIColorFromHex(0x7A7A7A) forState:(UIControlStateNormal)];
        plusButton.titleLabel.font = [UIFont systemFontOfSize:11];
        CGRect temp = plusButton.frame;
        
        temp.size = CGSizeMake(49, 49);
        
        plusButton.frame = temp;
        
        [plusButton addTarget:self  action:@selector(clickPlusButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:plusButton];
        
        _plusButton = plusButton;
        
        plusButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 13, 0, 0);
        plusButton.titleEdgeInsets = UIEdgeInsetsMake(35, -23, 0, 0);
    
        
    }
    return self;
}

- (void)clickPlusButton {

    if ([self.delegate respondsToSelector:@selector(tabbarDidClickPlusButton:)]) {
        
        [self.delegate tabbarDidClickPlusButton:self];
    }
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    CGPoint temp = self.plusButton.center;
    temp.x=self.frame.size.width/2;
    temp.y=self.frame.size.height/2;
    self.plusButton.center=temp;

    // 四个时的尺寸 
    CGFloat fourWidth = self.frame.size.width/4.f;
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5.f;
//    CGFloat tabbarButtonIndex = 0;
    for (NSInteger i = 0 ; i < self.subviews.count ; i ++ ) {
        UIView *child = self.subviews[i];
        
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            
            // 根据左右判断
            if (temp1.origin.x >= 0 && temp1.origin.x <= fourWidth)  {
                
                temp1.size.width=tabbarButtonW;
                temp1.origin.x= 0;
                child.frame=temp1;
                
            }
            
            if (temp1.origin.x >= fourWidth && temp1.origin.x <= 2*fourWidth)  {
                
                temp1.size.width=tabbarButtonW;
                temp1.origin.x= tabbarButtonW;
                child.frame=temp1;
                
            }
            
            if (temp1.origin.x >= 2*fourWidth && temp1.origin.x <= 3*fourWidth)  {
                
                temp1.size.width=tabbarButtonW;
                temp1.origin.x=3 * tabbarButtonW;
                child.frame=temp1;
                
            }
            if (temp1.origin.x >= 3*fourWidth && temp1.origin.x <= 4*fourWidth)  {
                
                temp1.size.width=tabbarButtonW;
                temp1.origin.x=4 * tabbarButtonW;
                child.frame=temp1;
                
            }

//            // 增加索引
//            tabbarButtonIndex++;
//            if (tabbarButtonIndex == 2) {
//                tabbarButtonIndex++;
//            }
        }

    }
    

}

@end
