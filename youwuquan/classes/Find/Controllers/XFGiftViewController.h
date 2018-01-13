//
//  XFGiftViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFGiftViewController;

@interface XFGiftCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *flowerButton;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UIImageView *diamondPic;
@property (nonatomic,strong) NSIndexPath *indexpath;

@property (nonatomic,copy) void(^clickFlowButtonBlock)(NSIndexPath *giftIndex);
@end

@protocol XFGiftVCDelegate <NSObject>

- (void)xfGiftVC:(XFGiftViewController *)giftVC didSuccessSendGift:(NSDictionary *)info;

@end

@interface XFGiftViewController : UIViewController

@property (nonatomic,strong) UIView *giftView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) NSArray *gifts;

@property (nonatomic,strong) id <XFGiftVCDelegate> delegate;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *iconUrl;

@end
