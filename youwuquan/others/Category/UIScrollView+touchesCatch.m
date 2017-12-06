//
//  UIScrollView+touchesCatch.m
//  huishangPlus
//
//  Created by mr.zhou on 2017/10/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "UIScrollView+touchesCatch.h"

@implementation UIScrollView (touchesCatch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
