//
//  XFSkillCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSkillModel.h"
@class XFSkillCollectionViewCell;

@protocol XFSkillCelldelegate <NSObject>

- (void)skillCell:(XFSkillCollectionViewCell *)cell didClickEditButtonWithStatus:(BOOL)status skillId:(NSString *)skillId;

@end

@interface XFSkillCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)clickEditButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (nonatomic,strong) XFSkillModel *model;

@property (nonatomic,strong) id <XFSkillCelldelegate> delegate;

@property (nonatomic,assign) BOOL isOpen;


@end
