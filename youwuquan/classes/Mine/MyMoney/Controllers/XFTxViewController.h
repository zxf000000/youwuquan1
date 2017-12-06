//
//  XFTxViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"


@interface XFtxCellNode : ASCellNode

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,strong) ASTextNode *timeNode;

@property (nonatomic,strong) ASTextNode *moneyNode;

@end

@interface XFTxViewController : XFOtherMainViewController



@end
