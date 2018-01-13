//
//  XFShareManager.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFShareManager.h"
#import "XFCreatShareImgManager.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <UShareUI/UShareUI.h>
//#import <WXApi.h>
#import "XFUserInfoManager.h"

@implementation XFShareManager

+ (void)shareImageWith:(UIImage *)image {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        [shareObject setShareImage:image];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];

        
    }];
    
}

+ (UIImage *)sharedUrl:(NSString *)urlStr image:(id )pic title:(NSString *)title detail:(NSString *)detail {

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:detail thumImage:pic];
        //设置网页地址
        shareObject.webpageUrl = urlStr;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
    }];
     
     return nil;
}


+ (UIImage *)sharedUrlImageWithBg:(NSString *)bgImg icon:(UIImage *)icon url:(NSString *)url {
    
    
    UIImage *shareImg = [XFCreatShareImgManager shareurlImgWithBgImage:[UIImage imageNamed:bgImg] iconImage:icon url:url];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //设置文本
        messageObject.text = @"尤物圈";
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
//        shareObject.thumbImage = icon;
        [shareObject setShareImage:shareImg];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
        
    }];
    
//    if (imageArray) {
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:url]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeImage];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//
//        [ShareSDK showShareActionSheet:nil
//         //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
    
//    }
    return nil;
    
}


+ (UIImage *)sharedImageWithBg:(NSString *)bgImg icon:(UIImage *)icon name:(NSString *)name userid:(NSString *)userid address:(NSString *)address {

    UIImage *shareImg = [XFCreatShareImgManager shareImgWithBgImage:[UIImage imageNamed:@"backgroundimage"] iconImage:icon name:name userId:userid address:address];
//
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //设置文本
        messageObject.text = @"尤物圈";
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        //        shareObject.thumbImage = icon;
        [shareObject setShareImage:shareImg];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
        
    }];
    //1、创建分享参数
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeImage];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//
//        //进行分享 (直接分享到朋友圈)
//        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
//             parameters:shareParams
//         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
//
//
//
//         }];
    
//
//        [ShareSDK showShareActionSheet:nil
//         //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
        
//    }
//
    
    
    return nil;
    
}


@end
