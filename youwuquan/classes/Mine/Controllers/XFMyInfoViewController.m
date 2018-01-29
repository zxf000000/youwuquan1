//
//  XFMyInfoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyInfoViewController.h"
#import "XFInfoChooseLabelViewController.h"
#import "PGDatePicker.h"
#import "XFLoginManager.h"
#import "XFTagsModel.h"
#import "XFMineNetworkManager.h"
#import "XFAddressViewController.h"

@interface XFMyInfoViewController () <PGDatePickerDelegate>

@property (nonatomic,copy) NSArray *tags;

@end

@implementation XFMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的资料";

    self.xzTextField.userInteractionEnabled = NO;
    
    self.saveButton.layer.cornerRadius = 22;
    
    self.phoneTexTField.userInteractionEnabled = NO;
    self.tableView.backgroundColor = UIColorHex(f4f4f4);
    
//    NSString *sanwei = self.userInfo[@"bwh"];
//
//    if (sanwei != nil && sanwei != NULL  && sanwei.length > 0) {
//
//        NSArray *saneriArr = [sanwei componentsSeparatedByString:@","];
//        self.xwTextField.text = saneriArr[0];
//        self.yyTextField.text = saneriArr[1];
//        self.tyTextField.text = saneriArr[2];
//
//    }
    // 三围
    if (self.userInfo[@"info"][@"bust"]) {
        
        self.xwTextField.text = [NSString stringWithFormat:@"%@",self.userInfo[@"info"][@"bust"]];
    }
    if (self.userInfo[@"info"][@"hip"]) {
        
        self.yyTextField.text = [NSString stringWithFormat:@"%@",self.userInfo[@"info"][@"hip"]];
    }
    if (self.userInfo[@"info"][@"waist"]) {
        
        self.tyTextField.text = [NSString stringWithFormat:@"%@",self.userInfo[@"info"][@"waist"]];
    }
    
    NSLog(@"%zd",[self.userInfo[@"info"][@"birthDay"] integerValue]);
    

    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:[self.userInfo[@"info"][@"birthDay"] integerValue]/1000];
    
    NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
    
    dataformatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [dataformatter stringFromDate:birthday];
    
    // 刷新个人信息
    self.nameTextField.text = self.userInfo[@"basicInfo"][@"nickname"];
    self.dateTextField.text = dateStr;
    if (self.userInfo[@"info"][@"height"]) {
        self.heightTextField.text = [NSString stringWithFormat:@"%@",self.userInfo[@"info"][@"height"]];
    }
    if (self.userInfo[@"info"][@"wechat"]) {
        self.wxTextField.text = self.userInfo[@"info"][@"wechat"];
    }
    
    self.phoneTexTField.text = self.userInfo[@"info"][@"phone"];
    
    if (dateStr.length > 0) {
        
        NSArray *date = [dateStr componentsSeparatedByString:@"-"];
        // 获取月份
        NSInteger month = [date[1] intValue];
        // 获取日
        NSInteger day = [date[2] intValue];
        
        NSString *AstroW = [XFToolManager getAstroWithMonth:month day:day];
        
        self.xzTextField.text = [NSString stringWithFormat:@"%@座",AstroW];
        
    }
    
    if (self.userInfo[@"info"][@"introduce"]) {
        self.desTextField.text = self.userInfo[@"info"][@"introduce"];

    }

    
}
- (IBAction)clickSaveButton:(id)sender {
    
    NSString *birthday = [NSString stringWithFormat:@"%@ 00:00",self.dateTextField.text];

    NSString *string = @"";
    
    for (NSInteger i = 0 ; i < self.tags.count ; i ++ ) {
        
        XFTagsModel *model = self.tags[i];
        
        if (i == 0) {
            
            string = [string stringByAppendingString:model.id];
        } else {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }
        
    }
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在保存"];
    
    [XFMineNetworkManager updateUserInfoWithBirthday:birthday height:self.heightTextField.text weight:@"180" bust:self.xwTextField.text waist:self.yyTextField.text hip:self.tyTextField.text starSign:self.xzTextField.text introduce:self.desTextField.text wechat:self.wxTextField.text nickname:self.nameTextField.text successBlock:^(id responseObj) {
        
        // 保存成功
        [XFToolManager changeHUD:HUD successWithText:@"修改成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}
- (IBAction)clickTagButton:(id)sender {
    
    // 直接跳到下个界面
    XFInfoChooseLabelViewController *chooseLabelVC = [[XFInfoChooseLabelViewController alloc] init];
    
    chooseLabelVC.sex = 0;
    
    chooseLabelVC.refreshTagsBlock = ^(NSArray *tags) {
        
        self.tags = tags;
        
    };
    
    [self.navigationController pushViewController:chooseLabelVC animated:YES];
    
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy_MM-dd";
    //
    //    NSString *dateStr = [formatter stringFromDate:[dateComponents date]];
    
    
    NSString *monthStr = @"";
    if (dateComponents.month > 9) {
        
        monthStr = [NSString stringWithFormat:@"%zd",dateComponents.month];
    } else {
        
        monthStr = [NSString stringWithFormat:@"0%zd",dateComponents.month];
        
    }
    NSString *dayStr = @"";
    if (dateComponents.day > 9) {
        
        dayStr = [NSString stringWithFormat:@"%zd",dateComponents.day];
    } else {
        
        dayStr = [NSString stringWithFormat:@"0%zd",dateComponents.day];
        
    }
    
    self.dateTextField.text = [NSString stringWithFormat:@"%zd-%@-%@",dateComponents.year,monthStr,dayStr];
    self.dateTextField.textColor = [UIColor blackColor];
    
//    self.dateTextField.text =  [NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,dateComponents.day];
    
    // 计算星座
    
    NSString *AstroW = [XFToolManager getAstroWithMonth:dateComponents.month day:dateComponents.day];
    
    self.xzTextField.text = [NSString stringWithFormat:@"%@座",AstroW];
    
    
    
}
- (IBAction)clickAddressButton:(id)sender {
    
    XFAddressViewController *addressVC = [[XFAddressViewController alloc] init];
    
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

- (IBAction)clickDateButton:(id)sender {
    
    [self.view endEditing:YES];
    // 日期选择器
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    //    datePicker.autoSelected = true;
    datePicker.middleText = true;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.minimumDate = [NSDate setYear:1790 month:8 day:5];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    
}


@end
