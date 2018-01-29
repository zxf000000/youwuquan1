//
//  XFConnectNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFConnectNode.h"


@implementation XFConnectNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = kBgGrayColor;
        _weChatButton = [[ASButtonNode alloc] init];
        _weChatButton.backgroundColor = UIColorHex(6D67E1);
        [_weChatButton setTitle:@"查看微信" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_weChatButton setImage:[UIImage imageNamed:@"find_wechat"] forState:(UIControlStateNormal)];
        _weChatButton.cornerRadius = 4;
        [self addSubnode:_weChatButton];
        
//        _phoneNode = [[ASButtonNode alloc] init];
//        _phoneNode.backgroundColor = UIColorHex(6D67E1);
//        [_phoneNode setTitle:@"查看电话" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        [_phoneNode setImage:[UIImage imageNamed:@"find_phone"] forState:(UIControlStateNormal)];
//        _phoneNode.cornerRadius = 4;
//        _phoneNode.backgroundColor = kMainRedColor;
//        [self addSubnode:_phoneNode];
        
        [_weChatButton addTarget:self action:@selector(clickWxButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
//        [_phoneNode addTarget:self action:@selector(clickNumberButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];

    }
    return self;
}

- (void)clickWxButton:(ASButtonNode *)button {
    
    if (self.clickWechatButton) {
        
        self.clickWechatButton();
        
    }
}

- (void)clickNumberButton:(ASButtonNode *)button {
    
    if (self.clickPhoneButton) {
        
        self.clickPhoneButton();
        
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _weChatButton.style.preferredSize = CGSizeMake((kScreenWidth - 35), 45);
//    ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_weChatButton,_phoneNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(16, 17, 16, 17)) child:_weChatButton];
    
}

@end
