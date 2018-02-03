//
//  XFSearchViewController.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/11.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMainViewController.h"

@interface XFSearchUserModel : NSObject

@property (nonatomic,copy) NSString *followed;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSString *identifications;
@property (nonatomic,copy) NSString *liked;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *vip;

@end

@interface XFSearchDeleteHeader : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,copy) void (^clickDeleteButtonBlock)(void);

@end

@interface XFSearchHeader : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@end

@interface XFSearchViewController : XFMainViewController

@property (nonatomic,copy) void(^backBlock)(void);

@end
