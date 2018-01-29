//
//  XFVIPCenterViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/22.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFVIPCenterViewController.h"
#import "XFMineNetworkManager.h"

@interface XFVIPCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signButton;
- (IBAction)clickSignButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *signDatLabel;
- (IBAction)clickBuyVipButton:(id)sender;

@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;

@property (nonatomic,strong) NSDictionary *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *diamondsNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation XFVIPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat iconWidth = 70 * kScreenWidth / 375.f - 2;
    self.iconView.layer.cornerRadius = iconWidth/2.f;
    self.iconView.layer.masksToBounds = YES;

    [self loadData];
}



- (void)loadData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFMineNetworkManager getMyWalletDetailWithsuccessBlock:^(id responseObj) {
        
        self.diamondsNumberLabel.text = [NSString stringWithFormat:@"%zd",[[(NSDictionary *)responseObj objectForKey:@"balance"] integerValue]];
        
        [HUD hideAnimated:YES];
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];

    [XFMineNetworkManager getMyVipInfoWithsuccessBlock:^(id responseObj) {
       
        
        
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
    self.userInfo = [XFUserInfoManager sharedManager].userInfo;
    
    [self.iconView setImageWithURL:[NSURL URLWithString:self.userInfo[@"basicInfo"][@"headIconUrl"]] options:(YYWebImageOptionProgressiveBlur)];
    
    
}



- (IBAction)clickSignButton:(id)sender {
}
- (IBAction)clickBuyVipButton:(id)sender {
}
@end
