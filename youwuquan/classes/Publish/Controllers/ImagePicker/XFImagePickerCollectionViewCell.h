//
//  XFImagePickerCollectionViewCell.h
//  chaofen
//
//  Created by mr.zhou on 2017/8/8.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFImagePickerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,copy) void(^selectedImageBlock)(BOOL isSelected,NSIndexPath *indexPath);

@property (nonatomic,assign) BOOL canSeleted;

@property (nonatomic,copy) void(^selectedEnoughBlock)();


@end
