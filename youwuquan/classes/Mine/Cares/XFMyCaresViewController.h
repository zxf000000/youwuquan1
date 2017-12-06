//
//  XFMyCaresViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"

@interface  XFMyCareViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) NSMutableArray *authIcons;

@property (nonatomic,strong) UIButton *careButton;

@end


@interface XFMyCaresViewController : XFOtherMainViewController

@end
