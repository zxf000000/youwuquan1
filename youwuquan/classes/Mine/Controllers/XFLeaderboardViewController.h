//
//  XFLeaderboardViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFRichlistModel : NSObject

@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *headIconUrl;
@property (nonatomic,copy) NSString *balance;
@property (nonatomic,copy) NSString *uid;



@end

@interface XFLeaderboardHeaderIconView : UIView

@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numberLabel;

@end

@interface XFLeaderboardViewController : UIViewController

@end
