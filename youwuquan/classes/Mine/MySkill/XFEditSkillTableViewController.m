//
//  XFEditSkillTableViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFEditSkillTableViewController.h"

@interface XFEditSkillTableViewController ()

@property (nonatomic,weak) UIImageView *headView;
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UITextField *timetextField;
@property (weak, nonatomic) IBOutlet UITextField *siteTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation XFEditSkillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"编辑技能";
    
    [self setupTopView];
    
    [XFToolManager setTopCornerwith:15 view:self.firstCell];
    
    self.doneButton.layer.cornerRadius = 21;
    
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickDoneButton {
    
    
    
}

- (void)setupTopView {
    
    UIImageView *headView = [[UIImageView alloc] init];
    
    headView.backgroundColor = [UIColor clearColor];
    
    headView.frame = CGRectMake(0, -kScreenWidth * 325/750.f, kScreenWidth, kScreenWidth * 325/750.f);
    
    self.tableView.contentInset = UIEdgeInsetsMake(kScreenWidth * 325/750.f, 0, 0, 0);
    
    self.headView = headView;
    
    [self.tableView insertSubview:headView atIndex:0];
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jnbj"]];
    
    self.tableView.backgroundView = backView;
    
}


@end
