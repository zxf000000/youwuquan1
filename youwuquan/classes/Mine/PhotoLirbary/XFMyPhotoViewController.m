//
//  XFMyPhotoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyPhotoViewController.h"
#import "XFOpenPhotoViewController.h"


@interface XFMyPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *wallView;

@property (weak, nonatomic) IBOutlet UIImageView *openView;
@property (weak, nonatomic) IBOutlet UIImageView *secView;

@end

@implementation XFMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupEvent];
}

#pragma mark - 照片墙
- (void)tapWall {
    
    XFOpenPhotoViewController *photoVC = [[XFOpenPhotoViewController alloc] init];
    photoVC.title = @"照片墙";
    [self.navigationController pushViewController:photoVC animated:YES];
    
}
// 公开相册
- (void)tapOpen {
    
    XFOpenPhotoViewController *photoVC = [[XFOpenPhotoViewController alloc] init];
    photoVC.title = @"公开相册";

    [self.navigationController pushViewController:photoVC animated:YES];
}
// 私密相册
- (void)tapSec {
    
    XFOpenPhotoViewController *photoVC = [[XFOpenPhotoViewController alloc] init];
    photoVC.title = @"私密相册";

    [self.navigationController pushViewController:photoVC animated:YES];
    
}

- (void)setupEvent {
    
    self.wallView.userInteractionEnabled = YES;
    self.openView.userInteractionEnabled = YES;
    self.secView.userInteractionEnabled = YES;
    
    self.wallView.layer.masksToBounds = YES;
    self.openView.layer.masksToBounds = YES;
    self.secView.layer.masksToBounds = YES;

    UITapGestureRecognizer *wallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWall)];
    [self.wallView addGestureRecognizer:wallTap];
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpen)];
    [self.openView addGestureRecognizer:openTap];
    
    UITapGestureRecognizer *sectap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSec)];
    [self.secView addGestureRecognizer:sectap];
    
}


@end
