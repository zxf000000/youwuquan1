//
//  XFStatusCommentViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusCommentViewController.h"
#import <IQKeyboardManager.h>

@interface XFStatusCommentViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIView *inputView;

@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation XFStatusCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCommentView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisppear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

#pragma mark - 键盘监听
- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    /*
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 44}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 689}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 645}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 44}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 623}, {375, 44}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     **/
    CGRect frame = [info[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (frame.origin.y == kScreenHeight) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.inputView.frame = CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44);
            self.shadowView.alpha = 0;
            
        }];
        
        
    } else {
        
        [self.view bringSubviewToFront:self.shadowView];
        [self.view bringSubviewToFront:self.inputView];
        CGRect inputFrame = self.inputView.frame;
        inputFrame.origin.y = frame.origin.y - 44 - 64;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.inputView.frame = inputFrame;
            self.shadowView.alpha = 1;
            
        }];
        
    }
    
}


- (void)setupCommentView {
    
    self.inputView = [[UIView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44))];
    
    [self.view addSubview:self.inputView];
    self.inputView.backgroundColor = [UIColor whiteColor];
    
    self.inputTextField = [[UITextField alloc] init];
    
    self.inputTextField.frame = CGRectMake(0, 0, kScreenWidth * 58/75.f, 44);
    
    self.inputTextField.backgroundColor = [UIColor whiteColor];
    self.inputTextField.placeholder = @"客官,来了就留下点什么吧...";
    self.inputTextField.borderStyle = UITextBorderStyleNone;
    self.inputTextField.font = [UIFont systemFontOfSize:12];
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 13, 10))];
    self.inputTextField.leftView = leftView;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.inputView addSubview:self.inputTextField];
    
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.frame = CGRectMake(kScreenWidth * 58/75.f, 0, kScreenWidth * 17/75.f, 44);
    self.sendButton.backgroundColor = kMainRedColor;
    [self.sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.inputView addSubview:self.sendButton];
    
    self.inputTextField.delegate = self;
    
    self.shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view insertSubview:self.shadowView belowSubview:self.inputView];
    self.shadowView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowView)];
    [self.shadowView addGestureRecognizer:tap];
    
}

- (void)hide {
    
    [self tapShadowView];
}

- (void)clickSendButton {
    

}

- (void)tapShadowView {
    
    [self.inputTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.shadowView.alpha = 0;
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
