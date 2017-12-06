//
//  XFCardView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFActorCardNode.h"
@class XFCardView;

@protocol XFCardViewDelegate <NSObject>

- (void)cardView:(XFCardView *)cardView didSelectedCardWithindex:(NSInteger)index;

@end


@interface XFCardView : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UILabel *totalLabel;

@property (nonatomic,strong) XFActorCardNode *cardView;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) id <XFCardViewDelegate> delegate;

@property (nonatomic,assign) BOOL canEdit;


- (void)setLayoutWithFrame:(NSArray *)frame;



@end
