//
//  XFApiClient.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


#define YBYHost @"http://118.126.102.173/api/v1/"
//#define YBYHost @"http://47.104.153.152:80/api/v1/"
//#define YBYHost @"http://192.168.123.179:80/api/v1/"

// 用户登录
#define YBYLogin @"signin"
// 用户登出
#define YBYLogout @"signout"

// 注册账号
#define YBYSignup @"signup"

@interface XFApiClient : NSObject


/**
 发送验证码

 @param phone 手机号
 @return url
 */
+ (NSString *)pathUrlForSendCodeWithNumber:(NSString *)phone;


/**
 注册账号

 @return url
 */
+ (NSString *)pathUrlForSignup;


/**
 重置密码

 @return url
 */
+ (NSString *)pathUrlForResetPwd;


/**
 登录

 @return url
 */
+ (NSString *)pathUrlForLogin;


/**
 登出

 @return url
 */
+ (NSString *)pathUrlForLogout;


/**
 发布动态

 @return url
 */
+ (NSString *)pathUrlForPublishStatus;


/**
 删除动态

 @param statusId 动态id
 @return url
 */
+ (NSString *)pathUrlForDeleteStatusWithStatusId:(NSString *)statusId ;


/**
 获取动态详情

 @param statusId 动态id
 @return url
 */
+ (NSString *)pathUrlForGetStatusWithStatusId:(NSString *)statusId;


/**
 评论动态

 @param statusId 动态id
 @return url
 */
+ (NSString *)pathUrlForCommentStatusWithId:(NSString *)statusId;


/**
 删除评论

 @param statusId 动态id
 @param commentId 评论id
 @return url
 */
+ (NSString *)pathUrlForDeleteCommentWithStatusId:(NSString *)statusId commentId:(NSString *)commentId;


/**
 回复评论

 @param statusId 动态id
 @param commentId 评论id
 @return url
 */
+ (NSString *)pathUrlForcommentCommentWithStatusId:(NSString *)statusId commentId:(NSString *)commentId ;


/**
 取消点赞

 @param statusId 动态id
 @return url
 */
+ (NSString *)pathUrlForLikeWithStatus:(NSString *)statusId;


/**
 取消点赞动态

 @param statusId 动态id
 @return url
 */
+ (NSString *)pathUrlForUnlikeStatus:(NSString *)statusId;


/**
 附近的人

 @return url
 */
+ (NSString *)pathUrlForGetNearby ;


/**
 查看视频详情

 @param videoId 视频id
 @return url
 */
+ (NSString *)pathUrlForGetVideoDetailWithId:(NSString *)videoId ;


/**
 获取视频评论

 @param videoId 视频id
 @return url
 */
+ (NSString *)pathUrlForGetVideoCommentsWithId:(NSString *)videoId;


/**
 评论视频

 @param videoId 视频id
 @return url
 */
+ (NSString *)pathUrlForCommentVideo:(NSString *)videoId;


/**
 删除视频评论

 @param videoId 视频id
 @param commentId 评论id
 @return url
 */
+ (NSString *)pathUrlForDeleteCommentForVideo:(NSString *)videoId comment:(NSString *)commentId;


/**
 回复视频评论

 @param videoId 视频id
 @param fartherId 评论id
 @return uyrl
 */
+ (NSString *)pathUrlForCommentVideoComment:(NSString *)videoId comment:(NSString *)fartherId;


/**
 上传文件

 @return url
 */
+ (NSString *)pathUrlForUploadFile;


/**
 粉丝列表

 @return url
 */
+ (NSString *)pathUrlForMyFans;


/**
 关注某人

 @param uid 被关注id
 @return url
 */
+ (NSString *)pathUrlForFollowOtherWithId:(NSString *)uid;


/**
 关注列表

 @return url
 */
+ (NSString *)pathUrlForFollows;


/**
 取消点赞某人

 @param uid 点赞id
 @return url
 */
+ (NSString *)pathUrlForUnLikeOther:(NSString *)uid;


/**
 点赞某人

 @param uid 某人id
 @return url
 */
+ (NSString *)pathUrlForLikeOther:(NSString *)uid ;


/**
 用户认证信息

 @return url
 */
+ (NSString *)pathUrlForGetMyDefine;

/**
 下载认证信息
 
 @return url
 */
+ (NSString *)pathUrlForDowndefineInfo;

/**
 上传认证信息
 @return url
 */
+ (NSString *)pathUrlForUpdefineInfo;


/**
 认证列表

 @return url
 */
+ (NSString *)pathUrlForAllDefineList;


/**
 查看用户认证信息

 @param uid uid
 @return url
 */
+ (NSString *)pathUrlForGetOtherDefineInfoWith:(NSString *)uid;


/**
 我的个人信息

 @return url
 */
+ (NSString *)pathUrlForGetUserInfo;


/**
 所有个人信息

 @return url
 */
+ (NSString *)pathUrlForGetAllUserInfo ;


/**
 更新用户信息

 @return url
 */
+ (NSString *)pathUrlForUpdateUserInfo;


/**
 设置性别

 @return url
 */
+ (NSString *)pathUrlForSetSex;


/**
 上传头像

 @return url
 */
+ (NSString *)pathUrlForUpdateIcon;


/**
 查看他人信息

 @param uid uid
 @return url
 */
+ (NSString *)pathUrlForGetOtherInfo:(NSString *)uid;


/**
 查看他人所有心胸

 @param uid uid
 @return url
 */
+ (NSString *)pathUrlForGetAllOtherInfo:(NSString *)uid;


/**
 用户照片墙

 @return url
 */
+ (NSString *)pathUrlForPhotoWall;

/**
 照片墙添加

 @return url
 */
+ (NSString *)pathUrlForAddPhotoWall;


/**
 首页数据

 @return url
 */
+ (NSString *)pathUrlForHomePage;


/**
 首页广告

 @return url
 */
+ (NSString *)pathUrlForHomeAd;

/**
 网红页

 @return url
 */
+ (NSString *)pathUrlForNethot;

/**
 视频页面

 @return url
 */
+ (NSString *)pathUrlForVideoPage;

/**
 视频广告

 @return url
 */
+ (NSString *)pathUrlForVideoPageAd ;

/**
 尤物页面
 @return url
 */
+ (NSString *)pathUrlForPrettyGirl;

/**
 获取融云token

 @return url
 */
+ (NSString *)pathUrlForGetImToken;

/**
 获取所有标签

 @return url
 */
+ (NSString *)pathUrlForGetAllTag;


/**
 关注标签

 @return url
 */
+ (NSString *)pathUrlForFollowTags;

/**
 设置自己的标签

 @return url
 */
+ (NSString *)pathUrlForSetTags;

/**
 获取他人照片墙信息

 @param userId id
 @return url
 */
+ (NSString *)pathUrlForGEtOtherWallWithId:(NSString *)userId;

// 私密相册
+ (NSString *)pathUrlForGetClosePhoto;
// 公开
+ (NSString *)pathUrlForGetMyOpenPhoto;

/**
 发现页面广告

 @return url
 */
+ (NSString *)pathUrlForGetFindAd;


/**
 关注数据

 @return url
 */
+ (NSString *)pathUrlForCareStatus ;


/**
 推荐动态

 @return url
 */
+ (NSString *)pathUrlForGetInviteStatus;

/**
 我的所有动态

 @return url
 */
+ (NSString *)pathUrlForGetAllMyStatus;

/**
 其他用户所有动态

 @param uid id
 @return ul
 */
+ (NSString *)pathUrlForGetOtherStatusWith:(NSString *)uid;

/**
 动态评论列表

 @param statusId id
 @return url
 */
+ (NSString *)pathUrlForGetStatusCommentListWith:(NSString *)statusId;



/**
 账户信息

 @return url
 */
+ (NSString *)pathUrlForGetBalance;

/**
 充值

 @return url
 */
+ (NSString *)pathUrlForCharge;

/**
 提现

 @return url
 */
+ (NSString *)pathUrlForwithDraw;

/**
 交易记录

 @return url
 */
+ (NSString *)pathUrlForTransaction;

// 解锁资源
+ (NSString *)pathUrlForUnlockStatusWithId:(NSString *)statusId;

// 解锁微信
+ (NSString *)pathUrlForUnlockWechat:(NSString *)userId;

/**
 下载相册

 @return url
 */
+ (NSString *)pathUrlForDownPics;

/**
 富豪榜

 @return url
 */
+ (NSString *)pathUrlForGetRichList;

/**
 账户详细信息

 @return url
 */
+ (NSString *)pathUrlForGetMyWalletDetailInfo;

/**
 获取相册封面

 @return url
 */
+ (NSString *)pathUrlForGetPhotoCover;

/**
 上传文件到七牛
 
 @return url
 */
+ (NSString *)pathUrlForUploadToQiniu;

/**
 获取礼物列表

 @return url
 */
+ (NSString *)pathUrlForGetGiftList;

/**
 打赏礼物

 @param uid uid
 @return url
 */
+ (NSString *)pathUrlForRewardWith:(NSString *)uid;

/**
 获取可以兑换多少金币/兑换金币

 @return url
 */
+ (NSString *)pathUrlForGetDiamindsCanExchangeCoinsNumber;

/**
 获取vip

 @return url
 */
+ (NSString *)pathUrlForGetVipTypes;

/**
 充值vip

 @param day
 @return url
 */
+ (NSString *)pathUrlForChargeVipWith:(NSString *)days;


/**
 获取每日任务

 @return url
 */
+ (NSString *)pathUrlForGetEverydayTask;

/**
 获取长期任务

 @return url
 */
+ (NSString *)pathUrlForGetLongTask;

/**
 分享链接

 @return url
 */
+ (NSString *)pathUrlForShareUrl;

/**
 分享成功

 @return url
 */
+ (NSString *)pathUrlForYBYShareSuccess;


/**
 阿里购买vip

 @return url
 */
+ (NSString *)pathUrlForChargeWithAlipay;

/**
 微信购买vip

 @return url
 */
+ (NSString *)pathUrlForChargeVipWithWechat;

/**
 钻石购买vip

 @return url
 */
+ (NSString *)pathUrlForChargeVipWithDiamonds;

/**
 获取vip信息

 @return url
 */
+ (NSString *)pathUrlForMyVipInfo;


/**
 更新位置信息

 @return url
 */
+ (NSString *)pathUrlForRefreshLocation;

/**
 获取VIP列表

 @return url
 */
+ (NSString *)pathUrlForGetVipList;

/**
 获取充值列表

 @return url
 */
+ (NSString *)pathUrlForGetCahrgeList;

/**
 获取上传token

 @return url
 */
+ (NSString *)pathUrlForGetQiniuToken;


/**
 第三方登录

 @param type 类型(WeChat,Weibo,QQ)
 @return url
 */
+ (NSString *)pathUrlForSignupWith:(NSString *)type;


/**
 更多网红

 @return url
 */
+ (NSString *)pathUrlForMoreNethot;
/**
 更多尤物

 @return url
 */
+ (NSString *)pathUrlForGetMorePretty;

/**
 hd视频

 @return url
 */
+ (NSString *)pathUrlForGetHdVideoList;

/**
 vr视频

 @return url
 */
+ (NSString *)pathUrlForGetVrVideoList;

/**
 更多主页shuju

 @return url
 */
+ (NSString *)pathUrlForGetHomeMoreData;



/**
 地址列表

 @return url
 */
+ (NSString *)pathUrlForAddressList;

/**
 添加地址

 @return url
 */
+ (NSString *)pathUrlForAddAddress;

/**
 更新地址

 @param addressId id
 @return url
 */
+ (NSString *)pathUrlForUpdateAddress:(NSString *)addressId;


/**
 查看是否注册过(第三放)

 @param uid uid
 @return url
 */
+ (NSString *)pathUrlForCheckIsHasUserWith:(NSString *)uid;


/**
 token登录

 @return url
 */
+ (NSString *)pathUrlForGetMyToken;

/**
 获取token

 @return url
 */
+ (NSString *)pathUrlForLoginWithToken;

// 解锁视频
+ (NSString *)pathUrlForUblockVideoWith:(NSString *)videoId;

/**
 根据时间获取个人通知

 @param date 上次时间
 @return url
 */
+ (NSString *)pathUrlForGetPersonNotification;

/**
 根据时间获取系统通知

 @param date 上次时间
 @return url
 */
+ (NSString *)pathUrlForGetSystemNotification;

/**
 获取搜索关坚持

 @return url
 */
+ (NSString *)pathUrlForGetSearchKeyword;

/**
 根据列表获取系统通知

 @return url
 */
+ (NSString *)pathUrlForGetSystemNotificationbyList;

/**
 获取分享背景图片

 @return url
 */
+ (NSString *)pathUrlForGetSharePicrures;

/**
 搜索用户

 @return url
 */
+ (NSString *)pathUrlForSearchUsers;
/**
 搜索动态

 @return url
 */
+ (NSString *)pathUrlForSearchPuhlishs;

/**
 订单状态

 @param orderId oid
 @return url
 */
+ (NSString *)pathUrlForGetOrderStatusWith:(NSString *)orderId;

@end
