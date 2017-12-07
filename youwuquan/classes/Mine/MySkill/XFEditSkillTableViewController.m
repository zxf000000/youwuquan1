//
//  XFEditSkillTableViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFEditSkillTableViewController.h"
#import "XFUserInfoNetWorkManager.h"

@interface XFEditSkillTableViewController ()

@property (nonatomic,weak) UIImageView *headView;
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UITextField *timetextField;
@property (weak, nonatomic) IBOutlet UITextField *siteTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;

@end

@implementation XFEditSkillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"技能";
    
    [self setupTopView];
    
//    [XFToolManager setTopCornerwith:15 view:self.firstCell];
    
    self.doneButton.layer.cornerRadius = 21;
    
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.skillNameLabel.text = self.skill.skillName;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickDoneButton {
    
    if (![self.timetextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入时间"];
        
        return;
    }
    
    if (![self.siteTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入地点"];
        
        return;
    }
    
    if (![self.priceTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入价格"];
        
        return;
    }
    
    if (![self.requestTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入要求"];
        
        return;
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在保存"];
    
    [XFUserInfoNetWorkManager changeOrlightSkillWithSkillno:self.skill.skillNo inviteTime:self.timetextField.text invitePlace:self.siteTextField.text inviteMoney:self.priceTextField.text inviteDemand:self.requestTextField.text successBlock:^(NSDictionary *responseDic) {
       
        if (responseDic) {
           
            [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.refreshSkillsBlock) {
                
                self.refreshSkillsBlock();
            }
            
        }
        
        [HUD hideAnimated:YES];
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

    }];
    
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
