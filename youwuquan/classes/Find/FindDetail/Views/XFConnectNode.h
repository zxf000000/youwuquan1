//
//  XFConnectNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class XFConnectNode;

@protocol XFConnectNodeDelegate <NSObject>


@end

@interface XFConnectNode : ASCellNode

@property (nonatomic,strong) ASButtonNode *weChatButton;
@property (nonatomic,strong) ASButtonNode *phoneNode;

@property (nonatomic,copy) void(^clickWechatButton)(void);
@property (nonatomic,copy) void(^clickPhoneButton)(void);


@end
