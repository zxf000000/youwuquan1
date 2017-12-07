//
//  XFEditSkillTableViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSkillModel.h"
@interface XFEditSkillTableViewController : UITableViewController

@property (nonatomic,strong) XFSkillModel *skill;

@property (nonatomic,copy) void(^refreshSkillsBlock)();

@end
