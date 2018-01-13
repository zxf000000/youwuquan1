//
//  XFMyAuthViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"

@interface XFMyAuthModel : NSObject

@property (nonatomic,copy) NSString *iconActiveUrl;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *identificationName;

@property (nonatomic,copy) NSString *identificationId;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *uid;

@end

@interface XFmyAuthCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) XFMyAuthModel *model;

@end

@interface XFMyAuthViewController : XFOtherMainViewController

@end
