//
//  XFMyInfoViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMainTableViewController.h"

@interface XFMyInfoViewController : XFMainTableViewController
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITextField *xzTextField;
@property (weak, nonatomic) IBOutlet UITextField *xwTextField;
@property (weak, nonatomic) IBOutlet UITextField *yyTextField;
@property (weak, nonatomic) IBOutlet UITextField *tyTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *wxTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTexTField;
@property (weak, nonatomic) IBOutlet UITextField *desTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (nonatomic,copy) NSDictionary *userInfo;

- (IBAction)clickSaveButton:(id)sender;

@end
