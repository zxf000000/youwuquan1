//
//  AppDelegate.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "XFMainTabbarViewController.h"
#import "XFLoginVCViewController.h"
// 引入JPush功能所需头文件
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "XFSnapShotViewController.h"

// youmnen
#import <UMSocialCore/UMSocialCore.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
//#import <WXApi.h>

#import "XFMessageViewController.h"
#import "XFMineViewController.h"
#import "XFMessageListViewController.h"

#import "XFLoginNetworkManager.h"
#import "XFMessageCacheManager.h"

#import <Bugly/Bugly.h>
#import "XFDiamondMessageContent.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "XFTabBarControllerConfig.h"
#import "CYLPlusButtonSubclass.h"

#define kRongyunAppkey @"mgb7ka1nmwztg"
#define kJPUSHAppKey @"1b12000e632a36af7363f2c7"
#define USHARE_DEMO_APPKEY @"5a559d19b27b0a4556000275"


@interface AppDelegate () <JPUSHRegisterDelegate,UITabBarControllerDelegate,RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // bugly
    [Bugly startWithAppId:@"2a434deb91"];

    #pragma mark - 捕获
    // app接受通知之后开启
    // 捕获通知
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    if (remoteNotificationUserInfo) {
        
        [[XFMessageCacheManager sharedManager] updateCacheWith:remoteNotificationUserInfo];
        
    }
    
    // 设置badge为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    


    // 初始化融云
    [[RCIM sharedRCIM] initWithAppKey:kRongyunAppkey];

    
    // 设置头像形状
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;

    // 设置用户信息代理
    [[RCIM sharedRCIM] setUserInfoDataSource:self];

    // 注册自定义发钻石消息
    /*!
     注册自定义的消息类型
     
     @param messageClass    自定义消息的类，该自定义消息需要继承于RCMessageContent
     @discussion 如果您需要自定义消息，必须调用此方法注册该自定义消息的消息类型，否则SDK将无法识别和解析该类型消息。
     @warning 如果您使用IMKit，请使用此方法注册自定义的消息类型；
     如果您使用IMLib，请使用RCIMClient中的同名方法注册自定义的消息类型，而不要使用此方法。
     */
    [[RCIMClient sharedRCIMClient] registerMessageType:XFDiamondMessageContent.class];
    
    // 融云推送设置
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    
    // 极光推送
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJPUSHAppKey
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
    // 自定义推送消息通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // rootVC
    self.window = [[UIWindow alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
    
//    XFSnapShotViewController *mainTabbar = [[XFSnapShotViewController alloc] init];
    self.mainTabbar = [[XFMainTabbarViewController alloc] init];
    
    self.mainTabbar.delegate = self;
    
    
    // 如果有推送通知,则直接跳转到消息界面
    if (remoteNotificationUserInfo) {
        
        self.mainTabbar.selectedIndex = 2;
        
    }
    
    
    if ([XFUserInfoManager sharedManager].userName) {
        
//        [XFLoginNetworkManager loginWithPhone:[XFUserInfoManager sharedManager].userName pwd:[XFUserInfoManager sharedManager].pwd longitude:@"100" latitude:@"100" progress:^(CGFloat progress) {
//
//
//        } successBlock:^(id responseObj) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self.window makeKeyAndVisible];
//
//            });
//
//
//        } failBlock:^(NSError *error) {
//
//        }];
        
//        [XFUserInfoManager sharedManager].userName = @"13040886496";
//        [XFUserInfoManager sharedManager].pwd = @"1234567a";
 
        [XFLoginNetworkManager loginWithPhone:[XFUserInfoManager sharedManager].userName pwd:[XFUserInfoManager sharedManager].pwd longitude:@"100" latitude:@"100" progress:^(CGFloat progress) {
            
            
        } successBlock:^(id responseObj) {
            
            NSLog(@"重新登录成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
            
            
        } failBlock:^(NSError *error) {
            
        }];
        
    }
    
    
    [CYLPlusButtonSubclass registerPlusButton];
    XFTabBarControllerConfig *tabBarControllerConfig = [[XFTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;

    tabBarController.delegate = self;

    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];

    
    [IQKeyboardManager sharedManager].enable = YES;
    
    return YES;
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

// AppDelegate class



#pragma mark - 会话用户消息获取
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    RCUserInfo *info;
    
    NSLog(@"%@------userId",userId);
    
    if ([userId isEqualToString:@"13140886496"]) {
        
         info = [[RCUserInfo alloc] initWithUserId:@"13140886496" name:@"小魂淡" portrait:@"http://d.hiphotos.baidu.com/image/pic/item/9f2f070828381f3062643d7ba3014c086f06f0e7.jpg"];

    } else {
        
         info = [[RCUserInfo alloc] initWithUserId:@"13040886496" name:@"网吧淡" portrait:@"http://d.hiphotos.baidu.com/image/pic/item/9f2f070828381f3062643d7ba3014c086f06f0e7.jpg"];

    }
    
    
    completion(info);
    
}

#pragma mark - tabbarVCdelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
    
    if (index == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomePAgeVisiable" object:nil];
            
        return YES;

    }
    
    
    if (index == 2 || index == 3) {
        
        if ([XFUserInfoManager sharedManager].userName == nil || [XFUserInfoManager sharedManager].userName.length == 0) {
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLoginVCNotification" object:nil];
            XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
            
            UINavigationController *naviLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [tabBarController presentViewController:naviLogin animated:YES completion:nil];
            
            return NO;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    

    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {

        if ([XFUserInfoManager sharedManager].userName != nil && [XFUserInfoManager sharedManager].userName.length > 0) {
            
            XFPublishViewController *publishVC = [[XFPublishViewController alloc] init];
            XFPublishNaviViewController *navi = [[XFPublishNaviViewController alloc] initWithRootViewController:publishVC];
            
            [tabBarController presentViewController:navi animated:YES completion:nil];
            
        } else {
            
            XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
            
            UINavigationController *naviLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [tabBarController presentViewController:naviLogin animated:YES completion:nil];
            
        }
        
    }
    
}

// 收到自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    // 极光
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
    
    //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"收到推送--------%@",userInfo);
    [[XFMessageCacheManager sharedManager] updateCacheWith:userInfo[@"content"]];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    // 融云注册token
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

// apns注册失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    if (@available (ios 10, * )) {
        
        // Required
        NSDictionary * userInfo = notification.request.content.userInfo;
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        
    }
    

}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 程序在后台的时候接受到推送消息
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark - 友盟配置
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx48c1f096be6cf592" appSecret:@"f448bf514ad77303e176e48e908dae23" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106475423"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"894460001"  appSecret:@"be21a2fc174295f968f8b951d935a05a" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    
    switch (state) {
            
        case UIApplicationStateActive:
        {
            
            
        }
            break;
        case UIApplicationStateInactive:
        {
            
            
        }
            break;
        case UIApplicationStateBackground:
        {
            
            
        }
            break;
            
            
    }
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"youwuquan"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
