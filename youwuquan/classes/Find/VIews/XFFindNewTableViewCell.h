//
//  XFFindNewTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFfindCellLayout.h"
@class XFFindNewTableViewCell;

@protocol XFFindCelldelegate <NSObject>

- (void)clickedCellForIndexPath:(NSIndexPath *)indexPath open:(BOOL)open;

@end

@interface XFFindNewTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) id <XFFindCelldelegate> delegate;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) CGFloat height;


@end
