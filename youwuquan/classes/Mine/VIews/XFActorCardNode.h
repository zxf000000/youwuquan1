//
//  XFActorCardNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFActorCardInfoView.h"

typedef NS_ENUM(NSInteger, XFActorCardType) {
  
    ThreeOne,
    ThreeTwo,
    ThreeThree,
    FourOne,
    FourTwo,
    FourThree,
    FiveOne,
    FiveTwo,
    FiveThree,
    SixOne,
    SixTwo,
    SixThree,
    SevenOne,
    SevenTwo,
    SevenThree,
    EightOne,
    EightTwo,
    EightThree,
    
    
};

@interface XFActorCardNode : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(XFActorCardType)type;

@property (nonatomic,assign) XFActorCardType type;

@property (nonatomic,assign) XFInfoCardViewType infoCardType;


- (void)setLayoutWith:(NSArray *)frames;

@end
