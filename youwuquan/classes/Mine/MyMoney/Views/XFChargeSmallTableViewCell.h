//
//  XFChargeSmallTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFChargeSmallTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *diamondsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *monneyButton;

@property (nonatomic,strong) NSDictionary *info;

@property (nonatomic,strong) NSIndexPath *indexPath;

- (IBAction)clickMOneyButton:(id)sender;

@property (nonatomic,copy) void(^clickButtonBlock)(NSIndexPath *indexPath, UIButton *moneyButton);

@end
