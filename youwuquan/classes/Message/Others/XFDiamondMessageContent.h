//
//  XFDiamondMessageContent.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/9.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCLocalMessageTypeIdentifier @"DiamondMessage"


@interface XFDiamondMessageContent : RCMessageContent <RCMessageCoding,RCMessagePersistentCompatible,RCMessageContentView>

/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
