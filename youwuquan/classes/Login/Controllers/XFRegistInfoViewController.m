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
    
    [self.birthButton setTitle:[NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,dateComponents.day] forState:(UIControlStateNormal)];
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
    
    // 获取标签
    [XFStatusNetworkManager getAllTagsWithsuccessBlock:^(NSDictionary *reponseDic) {
       
        if (reponseDic) {
            
            NSArray *datas = reponseDic[@"data"][0];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                [arr addObject:[XFTagsModel modelWithJSON:datas[i]]];
                
            }
            
            self.tags = arr.copy;
            
            //   直接跳到下个界面
            XFChooseLabelViewController *chooseLabelVC = [[XFChooseLabelViewController alloc] init];
            
            chooseLabelVC.sex = self.manButton.selected ? @"1" : @"0";
            chooseLabelVC.nickName = self.nickTextField.text;
            chooseLabelVC.birthday = self.birthButton.currentTitle;
            
            chooseLabelVC.tags = self.tags;
            [self.navigationController pushViewController:chooseLabelVC animated:YES];
        }
        
    } failedBlock:^(NSError *error) {
        
        
    }];
    

    
}
@end
