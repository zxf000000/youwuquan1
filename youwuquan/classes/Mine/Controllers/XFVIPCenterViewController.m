//
//  XFVIPCenterViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/22.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFVIPCenterViewController.h"
#import "XFMineNetworkManager.h"
#import "XFPayViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *vipDetailLabel;

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
       
        NSDictionary *vipInfo = (NSDictionary *)responseObj;
        if ([vipInfo[@"vipLevel"] isEqualToString:@"vip"]) {
            
            // 设置vip信息
            /*
             [0]    (null)    @"updateTime" : (long)1517830830000
             [1]    (null)    @"vipLevel" : @"vip"
             [2]    (null)    @"terminationDate" : (long)1543739767000
             **/
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[vipInfo[@"terminationDate"] longValue]/1000];
            
            //
            //
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *datestr = [format stringFromDate:date];
            self.vipDetailLabel.text = [NSString stringWithFormat:@"vip到期时间:%@",datestr];
            
        }
        
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
    self.userInfo = [XFUserInfoManager sharedManager].userInfo;
    
    [self.iconView setImageWithURL:[NSURL URLWithString:self.userInfo[@"basicInfo"][@"headIconUrl"]] options:(YYWebImageOptionProgressiveBlur)];
    
    
}



- (IBAction)clickSignButton:(id)sender {
}
- (IBAction)clickBuyVipButton:(id)sender {
    
    XFPayViewController *payVC = [[XFPayViewController alloc] init];
    
    //        payVC.type = XFPayVCTypeCharge;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}
@end
