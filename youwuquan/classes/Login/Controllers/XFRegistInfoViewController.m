//
//  XFRegistInfoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFRegistInfoViewController.h"
#import "PGDatePicker.h"
#import "XFChooseLabelViewController.h"
#import "XFStatusNetworkManager.h"
#import "XFTagsModel.h"
#import "XFLoginNetworkManager.h"
#import "XFMineNetworkManager.h"

@interface XFRegistInfoViewController () <PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
- (IBAction)birthdayButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
- (IBAction)clickSexButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
- (IBAction)clickNextStepButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *birthButton;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSArray *tags;

@end

@implementation XFRegistInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nextStepButton.layer.cornerRadius = 22;
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.nickTextField resignFirstResponder];
    
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
    
    [self.birthButton setTitle:[NSString stringWithFormat:@"%zd-%@-%@",dateComponents.year,monthStr,dayStr] forState:(UIControlStateNormal)];
    [self.birthButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
}

- (IBAction)birthdayButtonClicked:(id)sender {
    
    [self.nickTextField resignFirstResponder];
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
- (IBAction)clickSexButton:(UIButton *)sender {
    
    
    
    if (sender == self.manButton) {
        
        self.manButton.selected = YES;
        self.womanButton.selected = NO;
        
    } else {
        
        self.manButton.selected = NO;
        self.womanButton.selected = YES;
    }
    
    
}
- (IBAction)clickNextStepButton:(id)sender {
    
    [self.view endEditing:YES];

    
    if (![self.nickTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入昵称"];
        
        return;
    }
    
    if (![self.birthButton.currentTitle containsString:@"-"]) {
        
        [XFToolManager showProgressInWindowWithString:@"请设置生日"];
        
        return;
        
    }
    
    if (!self.manButton.selected && !self.womanButton.selected) {
        
        [XFToolManager showProgressInWindowWithString:@"选择性别"];
        
        return;
    }
    

    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *birthday = [dateFormatter dateFromString:self.birthButton.currentTitle];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@ 00:00",self.birthButton.currentTitle];
    
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    // 保存信息
    [XFLoginNetworkManager saveUserInfoWithnickName:self.nickTextField.text birthday:dateStr sex:self.manButton.selected?@"male":@"female" progress:^(CGFloat progress) {
        
    } successBlock:^(id responseObj) {
        
        // 成功,进入下个页面
        // 获取所有标签
        
        if (self.womanButton.selected) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
            // 女的不需要选标签
            [self dismissViewControllerAnimated:YES completion:nil];
            
            return;
            
        }
        
        [XFMineNetworkManager getAllTagsWithSuccessBlock:^(id responseObj) {
            
            [HUD hideAnimated:YES];
            NSArray *tags = (NSArray *)responseObj;
            
            NSMutableArray *tagsArr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < tags.count; i ++ ) {
                
                XFTagsModel *model = [XFTagsModel modelWithDictionary:tags[i]];
                
                [tagsArr addObject:model];
                
            }
            
            //   直接跳到下个界面
            XFChooseLabelViewController *chooseLabelVC = [[XFChooseLabelViewController alloc] init];
            chooseLabelVC.sex = self.manButton.selected?@"male":@"female";
            chooseLabelVC.tags = tagsArr.copy;
            [self.navigationController pushViewController:chooseLabelVC animated:YES];
            return;
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];

        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

        
    }];
    
    
//    // 获取标签
//    [XFStatusNetworkManager getAllTagsWithsuccessBlock:^(NSDictionary *reponseDic) {
//
//        if (reponseDic) {
//
//            NSArray *datas = reponseDic[@"data"][0];
//
//            NSMutableArray *arr = [NSMutableArray array];
//
//            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
//
//                [arr addObject:[XFTagsModel modelWithJSON:datas[i]]];
//
//            }
//
//            self.tags = arr.copy;
//

//        }
//
//    } failedBlock:^(NSError *error) {
//
//
//    }];
    

    
}
@end
