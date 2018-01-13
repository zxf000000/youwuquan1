//
//  XFShortVideoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFShortVideoViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>

@interface XFShortVideoViewController ()

@property (nonatomic,strong) PLShortVideoRecorder *shortVideoRecord;

@end

@implementation XFShortVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"录制";

//    [self setupRecordView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}


@end
