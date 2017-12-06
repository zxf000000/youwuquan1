//
//  XFMineViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMainViewController.h"

@interface XFMyTableCellNode : ASCellNode

@property (nonatomic,strong) ASImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,strong) ASDisplayNode *lineNode;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,assign) BOOL isEnd;

- (instancetype)initWithEnd:(BOOL)end ;
@end

@interface XFMineViewController : XFMainViewController



@end
