//
//  XFDateHerViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDateHerViewController.h"
#import "XFDateHerTableViewController.h"
#import "PGDatePicker.h"

@interface XFDateHerViewController () <PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *yueButton;

@property (nonatomic,strong) XFDateHerTableViewController *tableVC;

@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;

@end

@implementation XFDateHerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"约Ta";
    [self setupViews];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy_MM-dd";
    //
    //    NSString *dateStr = [formatter stringFromDate:[dateComponents date]];
    
    [self.tableVC.beginTimeButton setTitle:[NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,dateComponents.day] forState:(UIControlStateNormal)];
    [self.tableVC.beginTimeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
}


- (void)setupViews {
    
    self.tableVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"XFDateHerTableViewController"];
    
    [self.view addSubview:self.tableVC.view];
    self.tableVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    
    self.tableVC.clickTimeButtonBlock = ^{
      
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
        
    };
    
    self.yueButton.layer.cornerRadius = 5;
    
}

- (IBAction)clickYueButton:(id)sender {
    
    
}


@end
