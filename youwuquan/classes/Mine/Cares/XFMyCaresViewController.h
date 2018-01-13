//
//  XFMyCaresViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"

@interface XFMyCareModel : NSObject

@property (nonatomic,copy) NSString *followEach;
@property (nonatomic,copy) NSString *followedUid;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSArray *identificationIds;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *nickname;

@end

@interface  XFMyCareViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) NSMutableArray *authIcons;

@property (nonatomic,strong) UIButton *careButton;

@property (nonatomic,strong) XFMyCareModel *model;

@end


@interface XFMyCaresViewController : XFOtherMainViewController

@end
