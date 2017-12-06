//
//  XFHistoryCollectionViewCell.h
//  chaofen
//
//  Created by mr.zhou on 2017/7/15.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFLabelCollectionViewCell;

@protocol XFLabelCellDelegate <NSObject>

- (void)labelCell:(XFLabelCollectionViewCell *)cell didClickdeleteButtonWithIndex:(NSIndexPath *)indexpath;

@end

@interface XFLabelCollectionViewCell : UICollectionViewCell
/**
 *  标签
 */
@property (nonatomic,strong) UILabel *textLabel;
/**
 *  cell高度
 */
@property (nonatomic,assign) CGFloat itemHeight;
/**
 *  点击block回调
 */
@property (nonatomic,copy) void(^changesSelectedBlock)(NSIndexPath *indexPath,BOOL selected);
/**
 *  是否选择
 */
@property (nonatomic,assign) BOOL titleIsSelected;

@property (nonatomic,copy) void(^clickDeleteButtonForIndex)(NSIndexPath *indexpath);

@property (nonatomic,strong) NSIndexPath *indexPath;
/**
 *  单击label
 */
- (void)tapLabel;

@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,strong) id<XFLabelCellDelegate> delegate;

@property (nonatomic,copy) NSString *tagStr;


@end
