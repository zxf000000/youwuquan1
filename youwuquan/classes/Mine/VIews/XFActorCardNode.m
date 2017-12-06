//
//  XFActorCardNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActorCardNode.h"
#import "XFCardSizeCache.h"

@implementation XFActorCardNode


- (void)setLayoutWith:(NSArray *)frames {
    
    [self removeAllSubviews];
    
    self.backgroundColor = [UIColor blackColor];
    
    for (NSInteger i = 0 ; i < frames.count - 1; i ++ ) {
        
        CGRect frame = [frames[i] CGRectValue];
        
        if (i == frames.count - 2) {
            
            NSInteger type = [frames[frames.count - 1] integerValue];
            
            XFActorCardInfoView *view = [[XFActorCardInfoView alloc] initWithFrame:frame type:type];
            view.frame = frame;
            [self addSubview:view];
            
            continue;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:@"template_logo"];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
    }
    
}


@end
