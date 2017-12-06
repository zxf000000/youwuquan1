//
//  XFPublishAddImageViewCollectionViewCell.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/19.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFPublishAddImageViewCollectionViewCell;

@protocol XFpublishCollectionCellDelegate <NSObject>

- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickItemWithIndexPath:(NSIndexPath *)indexPath;

- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface XFPublishAddImageViewCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath *indexpath;

@property (weak, nonatomic) IBOutlet UIImageView *picView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic,strong) id<XFpublishCollectionCellDelegate> delegate;

@property (nonatomic,strong) UITapGestureRecognizer *tap;

- (void)removeTap;

@end
