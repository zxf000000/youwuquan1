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
    
    NSString *sanwei = self.userInfo[@"bwh"];
    
    if (sanwei != nil && sanwei != NULL  && sanwei.length > 0) {
        
        NSArray *saneriArr = [sanwei componentsSeparatedByString:@","];
        self.xwTextField.text = saneriArr[0];
        self.yyTextField.text = saneriArr[1];
        self.tyTextField.text = saneriArr[2];

    }
    
    // 刷新个人信息
    self.nameTextField.text = self.userInfo[@"userNike"];
    self.dateTextField.text = self.userInfo[@"birthday"];
    self.heightTextField.text = self.userInfo[@"height"];
    self.wxTextField.text = self.userInfo[@"weixin"];
    self.phoneTexTField.text = [XFUserInfoManager sharedManager].userName;
    self.xzTextField.text = self.userInfo[@"constellation"];
    self.desTextField.text = self.userInfo[@"synopsis"];
    
}
- (IBAction)clickSaveButton:(id)sender {
    
    NSString *name = self.nameTextField.text;
    NSString *birthday = self.dateTextField.text;
//    NSString *xingzuo = self.xzTextField.text;
    NSString *xw = self.xwTextField.text;
    NSString *yw = self.yyTextField.text;
    NSString *tw = self.tyTextField.text;
    NSString *height = self.heightTextField.text;
    NSString *wx = self.wxTextField.text;
    NSString *des = self.desTextField.text;
    
    
    NSString *string = @"";
    
    for (NSInteger i = 0 ; i < self.tags.count ; i ++ ) {
        
        XFTagsModel *model = self.tags[i];
        
        if (i == 0) {
            
            string = [string stringByAppendingString:model.labelName];
        } else {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",model.labelName]];
        }
        
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在保存"];
    
    [[XFLoginManager sharedInstance] saveUserInfoWithUserName:[XFUserInfoManager sharedManager].userName nickName:name birthday:birthday sex:nil tags:string roleNos:nil headUrl:nil height:height weight:nil bwh:[NSString stringWithFormat:@"%@,%@,%@",xw,yw,tw] weixin:wx synopsis:des successBlock:^(id reponseDic) {
        
        if (reponseDic) {
        
            [XFToolManager changeHUD:HUD successWithText:@"修改成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
        
        [HUD hideAnimated:YES];
        
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

        
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
    
    self.dateTextField.text =  [NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,dateComponents.day];
    
    // 计算星座
    
    NSString *AstroW = [XFToolManager getAstroWithMonth:dateComponents.month day:dateComponents.day];
    
    self.xzTextField.text = [NSString stringWithFormat:@"%@座",AstroW];
    
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
