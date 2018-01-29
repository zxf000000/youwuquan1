//
//  XFAddressTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/24.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFAddressModel.h"

@interface XFAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *provenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)clickEditbutton:(id)sender;
- (IBAction)clickDeleteButton:(id)sender;

@property (nonatomic,copy) void(^clickEditButtonBlock)(XFAddressModel *model);
@property (nonatomic,copy) void(^clickDeleteButtonBlock)(XFAddressModel *model);


@property (nonatomic,strong) XFAddressModel *model;

@end
