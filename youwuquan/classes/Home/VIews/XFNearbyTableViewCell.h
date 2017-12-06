//
//  XFNearbyTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFNearbyTableViewCell : UICollectionViewCell

@property (nonatomic,copy) NSArray *icons;

@property (nonatomic,copy) NSArray *iconImages;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
