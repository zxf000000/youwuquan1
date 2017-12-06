//
//  XFMoreFooter.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMoreFooter;

@protocol XFMoreFooterDelegate <NSObject>

- (void)didClickMoreButtonWithFooter:(XFMoreFooter *)footer section:(NSInteger )section;

@end

@interface XFMoreFooter : UIView

@property (nonatomic,strong) id <XFMoreFooterDelegate> delegate;

@property (nonatomic,assign) NSInteger section;


@end
