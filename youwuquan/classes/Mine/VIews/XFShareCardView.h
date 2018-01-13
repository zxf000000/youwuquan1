//
//  XFShareCardView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFShareCardView;

typedef NS_ENUM(NSInteger,XFCardShareViewtype) {
    
    XFCardShareViewtypePic,
    XFCardShareViewtypeAdd,
    
};

@protocol XFShareCardViewDelegate <NSObject>

- (void)xfShareCardView:(XFShareCardView *)shareCard didClickAddbutton:(UIButton *)addButton;

@end

@interface XFShareCardView : UIView

@property (nonatomic,strong) UIImageView *picView;

@property (nonatomic,strong) UIView *QRCodeBg;

@property (nonatomic,strong) UIImageView *QRCodeView;

@property (nonatomic,strong) UIImageView *logoView;

@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UILabel *addLabel;

@property (nonatomic,strong) UIImageView *shadowView;

@property (nonatomic,strong) UIImageView *textViewLeft;

@property (nonatomic,strong) UIImageView *textViewMiddle;

@property (nonatomic,strong) UIImageView *textViewRight;

@property (nonatomic,assign) XFCardShareViewtype type;

@property (nonatomic,strong) id <XFShareCardViewDelegate> delegate;

@property (nonatomic,copy) NSString *inviteUrl;

- (UIImage *)shotImage;

@end
