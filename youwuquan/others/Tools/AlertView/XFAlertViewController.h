//
//  XFAlertViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XFAlertViewType) {
    
    XFAlertViewTypeUnlockStatus,
    XFAlertViewTypeChangeCoin,
    
};

@interface XFAlertViewController : UIViewController

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) UIButton *anotherButton;

@property (nonatomic,strong) UIImageView *titleIcon;

@property (nonatomic,strong) UIButton *addButton;

@property (nonatomic,strong) UIButton *minusButton;

@property (nonatomic,strong) UIButton *diamondsButton;

@property (nonatomic,strong) UILabel *equalsLabel;

@property (nonatomic,strong) UIButton *coinButton;

@property (nonatomic,strong) UITextField *numberTextField;

@property (nonatomic,assign) XFAlertViewType type;

@property (nonatomic,copy) void(^clickDoneButtonBlock)(XFAlertViewController *alert);

@property (nonatomic,copy) void(^clickOtherButtonBlock)(XFAlertViewController *alert);



@end
