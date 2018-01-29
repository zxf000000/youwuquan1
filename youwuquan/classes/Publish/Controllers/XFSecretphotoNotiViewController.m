//
//  XFSecretphotoNotiViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/19.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFSecretphotoNotiViewController.h"
#import "XFPublishSecretPhotoViewController.h"

@interface XFSecretphotoNotiViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation XFSecretphotoNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cancelButton.layer.cornerRadius = 5;
    self.doneButton.layer.cornerRadius = 5;
}

- (IBAction)clickCancelButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickDoneButton:(id)sender {
    
    XFPublishSecretPhotoViewController *secVC = [[XFPublishSecretPhotoViewController alloc] init];
    secVC.openpics = self.openpics;
    secVC.text = self.text;
    secVC.tags = self.tags;
    [self.navigationController pushViewController:secVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    
}


@end
