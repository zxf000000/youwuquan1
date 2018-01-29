//
//  XFImageNodeManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/25.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFImageNodeManager : NSObject <ASImageCacheProtocol, ASImageDownloaderProtocol>

+ (XFImageNodeManager *)sharedImageManager;

@end
