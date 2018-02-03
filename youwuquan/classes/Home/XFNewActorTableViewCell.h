//
//  XFNewActorTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kActorSecondCellHeight (((kScreenWidth - 10 - 10 - 4)/3 * 190/235.f) * 3 + 14 + 50)

@interface XFNewActorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
