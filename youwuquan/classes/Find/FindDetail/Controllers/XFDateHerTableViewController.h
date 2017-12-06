//
//  XFDateHerTableViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFDateHerTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *beginTimeButton;

@property (nonatomic,copy) void(^clickTimeButtonBlock)(void);

@end
