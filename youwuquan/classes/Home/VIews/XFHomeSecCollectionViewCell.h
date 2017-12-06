//
//  XFHomeSecCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFHomeSecCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *spaceButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picVIew;

@property (nonatomic,copy) NSArray *icons;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;

@end
