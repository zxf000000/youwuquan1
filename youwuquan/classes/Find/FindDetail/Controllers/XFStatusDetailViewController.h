//
//  XFStatusDetailViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFStatusCommentViewController.h"

@interface XFStatusCenterNode : ASCellNode

@property (nonatomic,strong) ASTextNode *titleNode;

@end

@interface XFStatusBottomNode : ASCellNode

@property (nonatomic,strong) ASButtonNode *moreButton;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,copy) void(^clickMoreButtonBlock)();

@end

@interface XFStatusDetailViewController : XFStatusCommentViewController

@end
