//
//  XFHomeTopHeaderReusableView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HomeHeaderType) {
    
    Home,
    NetHot,
    
};

@interface XFHomeTopHeaderReusableView : UICollectionReusableView <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (weak, nonatomic) IBOutlet UIImageView *centerPiciew;
@property (weak, nonatomic) IBOutlet UIView *centerShadow;
@property (weak, nonatomic) IBOutlet UIButton *centerbutton;

@property (nonatomic,assign) HomeHeaderType type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineTop;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@end
