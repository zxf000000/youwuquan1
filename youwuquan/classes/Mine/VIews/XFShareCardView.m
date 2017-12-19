//
//  XFShareCardView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFShareCardView.h"

#define kRatio (kScreenWidth / 375.f)

@implementation XFShareCardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.shadowColor = UIColorHex(808080).CGColor;
        self.layer.shadowOpacity = 0.7;
        
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        
        _picView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, frame.size.width, frame.size.height))];
        [self addSubview:_picView];
        
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.layer.cornerRadius = 10;
        _picView.layer.masksToBounds = YES;
        
        
        _shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_shadow"]];
        [self addSubview:_shadowView];
        _shadowView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _shadowView.hidden = YES;
        
        _textViewLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_join"]];
        [self addSubview:_textViewLeft];
        
        _textViewMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_wait"]];
        [self addSubview:_textViewMiddle];
        
        _textViewRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_ywq"]];
        [self addSubview:_textViewRight];
        
        _QRCodeBg = [[UIView alloc] init];
        _QRCodeBg.backgroundColor = [UIColor whiteColor];
        _QRCodeBg.layer.cornerRadius = 10;
        [self addSubview:_QRCodeBg];
        
        _QRCodeView = [[UIImageView alloc] initWithImage:[self creatQRcodeWithInfo:[XFUserInfoManager sharedManager].userInfo[@"inviteUrl"] withSize:(CGSizeMake(180, 180))]];
        [_QRCodeBg addSubview:_QRCodeView];
        
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_logo"]];
        [self addSubview:_logoView];
        
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"share_more"] forState:(UIControlStateNormal)];
        [self addSubview:_addButton];
        
        [_addButton addTarget:self action:@selector(clickAddbutton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"自定义图片";
        _addLabel.textColor = kMainRedColor;
        _addLabel.font = [UIFont systemFontOfSize:15];
        _addLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_addLabel];
        
        _textViewMiddle.centerX = width/2;
        _textViewMiddle.top = height - 99 - 27;
        _textViewMiddle.width = 85;
        _textViewMiddle.height = 99;
        
        _QRCodeBg.left = 12;
        _QRCodeBg.top = _textViewMiddle.top;
        _QRCodeBg.width = _QRCodeBg.height = 79;
        
        
        _logoView.left = width - 12 - 79;
        _logoView.top = _textViewMiddle.top;
        _logoView.width = _logoView.height = 79;
        
        _textViewLeft.centerX = _QRCodeBg.centerX;
        _textViewLeft.top = _QRCodeBg.bottom + 10;
        
        
        _textViewRight.centerX = _logoView.centerX;
        _textViewRight.top = _logoView.bottom + 10;
        
        _QRCodeView.frame = CGRectMake(7.5, 7.5, _QRCodeBg.width - 15, _QRCodeBg.height - 15);
        
        _addButton.top = _textViewMiddle.top/2 - 45 - 20;
        _addButton.left = width/2 - 45;
        _addButton.width = _addButton.height = 90;
        
        _addLabel.left = width/2 - 60;
        _addLabel.top = _addButton.bottom + 20;
        _addLabel.height = 21;
        _addLabel.width = 120;
        
        
    }
    return self;
}

- (UIImage *)creatQRcodeWithInfo:(NSString *)path withSize:(CGSize)imageSize {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [path dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [UIImage imageWithCIImage:outPutImage];
    
}

- (void)clickAddbutton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(xfShareCardView:didClickAddbutton:)]) {
        
        [self.delegate xfShareCardView:self didClickAddbutton:sender];
    }
    
}


- (void)setType:(XFCardShareViewtype)type {
    
    if (type == XFCardShareViewtypePic) {
        
        _QRCodeBg.hidden = NO;
        _logoView.hidden = NO;
        _textViewLeft.hidden = NO;
        _textViewMiddle.hidden = NO;
        _textViewRight.hidden = NO;
        _picView.hidden = NO;
        _addButton.hidden = YES;
        _addLabel.hidden = YES;
        _shadowView.hidden = YES;
        
    } else {
        
        _QRCodeBg.hidden = YES;
        _logoView.hidden = YES;
        _textViewLeft.hidden = YES;
        _textViewMiddle.hidden = YES;
        _textViewRight.hidden = YES;
        _picView.hidden = YES;
        _addButton.hidden = NO;
        _addLabel.hidden = NO;
        _shadowView.hidden = NO;
        
    }
    
}

@end
