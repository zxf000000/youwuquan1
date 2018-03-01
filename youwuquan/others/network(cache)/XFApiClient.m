//
//  XFApiClient.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFApiClient.h"

//#define YBYHost @"http://192.168.1.150:8000/api/v1/"
//#define YBYHost @"http://47.104.153.152:80/api/v1/"
//#define YBYHost @"http://192.168.123.179:80/api/v1/"

// 用户登录
#define YBYLogin @"signin"
// 用户登出
#define YBYLogout @"signout"

// 发送验证码
#define YBYSendCode(phone) [NSString stringWithFormat:@"signup/sendcode/%@",(phone)]
// 修改密码
#define YBYResetPwd @"reset-password"

// 获取融云token
#define YBYGetImToken @"im/token"

// 上传文件到骑牛
#define YBYUploadToQiniu @"upload/image"

// 发布动态
#define YBYPublishStatus @"publish"
// 操作动态
#define YBYStatus(publishId) [NSString stringWithFormat:@"publish/%@",(publishId)]
// 动态评论吧列表
#define YBYStatusCommentList(publishId) [NSString stringWithFormat:@"publish/%@/comment",(publishId)]
// 评论动态
#define YBYCommentStatus(publishId) [NSString stringWithFormat:@"publish/%@/comment",(publishId)]
// 删除评论
#define YBYDeleteStatusComment(publishId,commentId) [NSString stringWithFormat:@"publish/%@/comment/%@",(publishId),(commentId)]
// 回复评论
#define YBYCommentComments(publishId,fartherId) [NSString stringWithFormat:@"publish/%@/comment/%@",(publishId),(fartherId)]
// 点赞/取消点赞
#define YBYLikeStatus(publishId) [NSString stringWithFormat:@"publish/%@/like",(publishId)]
// 点赞列表
#define YBYGetLikeListWithStatusId(publishId) [NSString stringWithFormat:@"publish/%@/like",(publishId)]


// 附近的人
#define YBYNearby @"page/homepage/nearby"

// 查看视频详情
#define YBYVideoDetail(videoId) [NSString stringWithFormat:@"video/%@",(videoId)]
// 获取视频评论/添加评论
#define YBYGetVideoComments(videoId) [NSString stringWithFormat:@"video/%@/comment",(videoId)]
// 评论视频
#define YBYCommentVideo(videoId) [NSString stringWithFormat:@"video/%@/comment",(videoId)]
// 删除视频评论
#define YBYDeleteComment(videoId,commentId) [NSString stringWithFormat:@"video/%@/comment/%@",(videoId),(commentId)]
// 回复评论
#define YBYCommentComment(videoId,fatherId) [NSString stringWithFormat:@"video/%@/comment/%@",(videoId),(fatherId)]

// 文件上传 (非阿里云)
#define YBYUpload @"upload"

// 查看所有标签(用户)
#define YBYAllTag @"tag/all"
// 关注标签
#define YBYFollowTag @"tag/follow-withclean"
// 设置自己的标签
#define YBYSetTags @"tag/set-withclean"

// TODO:

// 用户粉丝
#define YBYFans @"fans"
// 关注某人
#define YBYFollow(uid) [NSString stringWithFormat:@"follow/%@",(uid)]
// 查看自己的关注列表
#define YBYFollows @"follows"
// 点赞/取消点赞某人
#define YBYLike(uid) [NSString stringWithFormat:@"like/%@",(uid)]

// 认证
// 查看自己的认证列表
#define YBYDefine @"identification"
// 认证信息下载/上传
#define YBYDownDefineInfo @"identification/apply"
// 所有认证信息
#define YBYdefineList @"identification/list"
// 查看某用户的认证信息
#define YBYGetUserDefineInfo(uid) [NSString stringWithFormat:@"identification/%@",(uid)]


// 用户信息
// 查看自己用户信息(存储/更新)
#define YBYGetmyInfo @"user"
// 查看用户所有信息
#define YBYGetAllMyInfo @"user/all"
// 设定性别
#define YBYSetSex @"user/gender"
// 上传头像
#define YBYSetIcon @"user/head-icon"
// 查看用户信息
#define YBYGetOtherInfo(uid) [NSString stringWithFormat:@"user/%@",(uid)]
// 查看所有用户信息
#define YBYGetAllOtherInfo(uid) [NSString stringWithFormat:@"user/%@/all",(uid)]

// 照片墙/添加照片墙
#define YBYGetPhotoWall @"user/photo-wall"

// 查看他人照片墙
#define YBYGetOtherWall(uid) [NSString stringWithFormat:@"user/%@/photo-wall",(uid)]

// 私密相册
#define YBYGEtMyClosePhoto @"user/picture/close"
// 公开相册
#define YBYGEtMyOpenPhoto @"user/picture/open"
// 下载相册
#define YBYGetDownPics @"photographs"

// 相册封面
#define YBYGetPhotoCover @"user/cover"

// 首页数据
#define YBYHomeData @"page/homepage"
#define YBYHomeDataMore @"page/homepage/more"

// 首页广告
#define YBYHomeAd @"page/homepage/advertisements"
// 网红页面
#define YBYNetHotData @"page/hot-person"
#define YBYNetHotDataMore @"page/hot-person/more"

// 视频页面
#define YBYVideoPage @"page/video"
#define YBYVideoPageHD @"page/video/hd"
#define YBYVideoPageVR @"page/video/vr"

// 视频页面广告
#define YBYVideoAd @"page/video/advertisements"
// 尤物页面
#define YBYPrettyGirl @"page/youwu"
#define YBYPrettyGirlMore @"page/youwu/more"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 账户相关
#define YBYGetBalance @"user/balance"
// 充值
#define YBYCharge @"user/balance/recharge"
// 提现
#define YBYWithDraw @"user/balance/withdraw"
// 交易记录
#define YBYTransactions @"user/transactions"
// 获取富豪榜
#define YBYGetRichList @"ranking/balance"
// 充值列表
#define YBYGetChargeList @"user/balance/recharge/list"
// 账户详细信息
#define YBYGetWalletDetailInfo @"user/account"

// 解锁资源
#define YBYUnlockPublish(publishId) [NSString stringWithFormat:@"unlock/publish/%@",(publishId)]
// 获取用户微信
#define YBYGetWechat(uid) [NSString stringWithFormat:@"unlock/wechat/%@",(uid)]

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 动态页面数据
// 动态页面广告
#define YBYGetFindAd @"activity/list"
// 关注的动态
#define YBYGetFollowStatus @"page/publish/follows"
// 我的所有动态
#define YBYGetAllMyStatus @"page/publish/mine"
// 推荐的动态
#define YBYGetInviteStatus @"page/publish/recommends"
// 用户所有动态
#define YBYAllUserStatius(uid) [NSString stringWithFormat:@"page/publish/user/%@",(uid)]

// 获取礼物列表
#define YBYGetGiftList @"reward/list"
// 打赏某人礼物
#define YBYRewardSomeone(userId) [NSString stringWithFormat:@"reward/%@",(userId)]
// 获取钻石可以兑换多少金币
#define YBYGetDiamondsCanExchangeCoinsNumber @"user/balance/exchange"

// 获取天数需要多少钻石
#define YBYChargeVipWith(days) [NSString stringWithFormat:@"user/vip/day/%@",(days)]

// 充值(ali)
#define YBYChargeVipAlipay @"user/vip/buy-alipay"
// 充值(wechat)
#define YBYChargeVipWechat @"user/vip/buy-wechat"
// 充值(钻石)
#define YBYChargeVipDiamonds @"user/vip/buy-usediamond"
// 获取vip类型
#define YBYGetVipTypes @"user/vip/list"

// 每日任务
#define YBYGetEverydayMission @"tasks/today"
// 长期任务
#define YBYGetLongMission @"tasks/longtime"

// 获取分享链接
#define YBYShareGiftUrl @"share/url"
// 分享成功调用
#define YBYShareSuccess @"share/success"

// 个人vip信息
#define YBYGetVipInfo  @"user/vip"
// vip列表
#define YBYGetVipList @"user/vip/list"
// 更新用户位置
#define YBYRefreshUserLocation @"position"

// 获取七牛上传token
#define YBYGetQiniuUploadToken @"qiuniu/token"

// 第三番登录绑定
#define YBYSignUpWith(type) [NSString stringWithFormat:@"signup/%@",(type)]

// 获取地址列表
#define YBYGetAddressList @"user/address/list"
// 添加地址
#define YBYAddAddress @"user/address"
// 修改地址
#define YBYUpdateaddressWith(id) [NSString stringWithFormat:@"user/address/%@",(id)]

// 查看是否注册过
#define YBYCheckIsHasUserWithId(id) [NSString stringWithFormat:@"signup/%@",(id)]

#define YBYGetMyToken @"token"

#define YBYLoginWithToken @"signin/use-token"

#define YBYUnlockVideoWithId(videoId) [NSString stringWithFormat:@"unlock/video/%@",(videoId)]

// 根据上次日期获取时间节点的个人通知
#define YBYGetNotificationsByDate @"message/personal/by-date"
// 根据上次日期获取节点时间系统通知
#define YBYGetSystemNotificationWithDate @"message/system/by-date"
// 获取系统通知列表
#define YBYGetSystemList @"message/system/list"
// 搜索关键词
#define YBYGetSearchKeyword @"search/words"
// 获取分享插图
#define YBYGetShareCardPics @"share/pictures"
// 搜索用户
#define YBYSearchUsers @"search/users"
// 搜索动态
#define YBYsearchStatus @"search/publishs"

#define YBYGetTradeStatusWithID(orderId) [NSString stringWithFormat:@"pay/order/%@",(orderId)]

// 报名活动
#define YBYCheckinActivityWithID(activityID) [NSString stringWithFormat:@"activity/check-in/%@",(activityID)]
// 活动付费
#define YBYBuyActivityWithId(activityID) [NSString stringWithFormat:@"activity/pay/%@",(activityID)]

// 活动详情
#define YBYGetActivityDetailWithId(activityID) [NSString stringWithFormat:@"activity/%@",(activityID)]

// 内购充值钻石
#define YBYIAPChargeDiamond @"user/balance/ios/diamond"
// 内购买会员
#define YBYIAPChargeVip @"user/balance/ios/vip"


@implementation XFApiClient
// 发送验证码
+ (NSString *)pathUrlForSendCodeWithNumber:(NSString *)phone {
    
    NSLog(@"%@",YBYSendCode(phone));
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSendCode(phone)];
}

// 注册账号
+ (NSString *)pathUrlForSignup {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSignup];
}

// 重置密码
+ (NSString *)pathUrlForResetPwd {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYResetPwd];
}

// 登录
+ (NSString *)pathUrlForLogin {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLogin];
}

// 登出
+ (NSString *)pathUrlForLogout {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLogout];
}

// 发布动态
+ (NSString *)pathUrlForPublishStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYPublishStatus];
}

// 删除一条动态
+ (NSString *)pathUrlForDeleteStatusWithStatusId:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYStatus(statusId)];
}

// 获取一条动态
+ (NSString *)pathUrlForGetStatusWithStatusId:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYStatus(statusId)];
}

// 评论动态
+ (NSString *)pathUrlForCommentStatusWithId:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCommentStatus(statusId)];
    
}

// 删除评论
+ (NSString *)pathUrlForDeleteCommentWithStatusId:(NSString *)statusId commentId:(NSString *)commentId {

    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYDeleteStatusComment(statusId,commentId)];

}

// 回复评论
+ (NSString *)pathUrlForcommentCommentWithStatusId:(NSString *)statusId commentId:(NSString *)commentId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCommentComments(statusId, commentId)];
}

// 取消点赞
+ (NSString *)pathUrlForLikeWithStatus:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLikeStatus(statusId)];
}

// 点赞
+ (NSString *)pathUrlForUnlikeStatus:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLikeStatus(statusId)];
}

// 附近的人
+ (NSString *)pathUrlForGetNearby {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYNearby];
}

// 查看视频详情
+ (NSString *)pathUrlForGetVideoDetailWithId:(NSString *)videoId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYVideoDetail(videoId)];
}
// 获取视频评论
+ (NSString *)pathUrlForGetVideoCommentsWithId:(NSString *)videoId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetVideoComments(videoId)];
}

// 添加评论
+ (NSString *)pathUrlForCommentVideo:(NSString *)videoId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetVideoComments(videoId)];

}

// 删除评论
+ (NSString *)pathUrlForDeleteCommentForVideo:(NSString *)videoId comment:(NSString *)commentId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYDeleteComment(videoId, commentId)];
}

//  回复视频评论
+ (NSString *)pathUrlForCommentVideoComment:(NSString *)videoId comment:(NSString *)fartherId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCommentComment(videoId, fartherId)];
}

// 上传文件
+ (NSString *)pathUrlForUploadFile {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUpload];
}

// 自己的粉丝列表
+ (NSString *)pathUrlForMyFans {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYFans];
}

// 关注
+ (NSString *)pathUrlForFollowOtherWithId:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYFollow(uid)];
}

// 自己的关注列表
+ (NSString *)pathUrlForFollows {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYFollows];
}

// 取消喜欢某人
+ (NSString *)pathUrlForUnLikeOther:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLike(uid)];
}

// 喜欢某人
+ (NSString *)pathUrlForLikeOther:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLike(uid)];
}

// 用户认证信息列表
+ (NSString *)pathUrlForGetMyDefine {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYDefine];
}

// 认证信息下载
+ (NSString *)pathUrlForDowndefineInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYDownDefineInfo];
}

// 认证信息上传
+ (NSString *)pathUrlForUpdefineInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYDownDefineInfo];
}

// 查看所有认证信息
+ (NSString *)pathUrlForAllDefineList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYdefineList];
}

// 查看用户认证信息
+ (NSString *)pathUrlForGetOtherDefineInfoWith:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetUserDefineInfo(uid)];
}


// 个人信息
+ (NSString *)pathUrlForGetUserInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetmyInfo];
}

// 所有个人信息
+ (NSString *)pathUrlForGetAllUserInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAllMyInfo];
}

// 更新用户信息
+ (NSString *)pathUrlForUpdateUserInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetmyInfo];
}

// 设置性别
+ (NSString *)pathUrlForSetSex {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSetSex];
}
// 上传头像
+ (NSString *)pathUrlForUpdateIcon {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSetIcon];
}

// 查看他人信息
+ (NSString *)pathUrlForGetOtherInfo:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetOtherInfo(uid)];
}

// 查看他人所有信息
+ (NSString *)pathUrlForGetAllOtherInfo:(NSString *)uid {

    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAllOtherInfo(uid)];
}

// 用户照片墙
+ (NSString *)pathUrlForPhotoWall {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetPhotoWall];
}

// 添加照片墙信息
+ (NSString *)pathUrlForAddPhotoWall {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetPhotoWall];
}

// 首页数据
+ (NSString *)pathUrlForHomePage {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYHomeData];
}

// 首页广告
+ (NSString *)pathUrlForHomeAd {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYHomeAd];
}

// 网红
+ (NSString *)pathUrlForNethot {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYNetHotData];
}

// 视频页面
+ (NSString *)pathUrlForVideoPage {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYVideoPage];
}

// 视频广告
+ (NSString *)pathUrlForVideoPageAd {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYVideoAd];
}

// 尤物页面
+ (NSString *)pathUrlForPrettyGirl {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYPrettyGirl];
}

// 融云token
+ (NSString *)pathUrlForGetImToken {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetImToken];
}

// 所有标签
+ (NSString *)pathUrlForGetAllTag {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYAllTag];
}

// 关注标签
+ (NSString *)pathUrlForFollowTags {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYFollowTag];
}

// 设置标签
+ (NSString *)pathUrlForSetTags {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSetTags];
}

+ (NSString *)pathUrlForGEtOtherWallWithId:(NSString *)userId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetOtherWall(userId)];
}

// 私密相册
+ (NSString *)pathUrlForGetClosePhoto {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGEtMyClosePhoto];
}

// 公开
+ (NSString *)pathUrlForGetMyOpenPhoto {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGEtMyOpenPhoto];
}

// 获取账户信息
+ (NSString *)pathUrlForGetBalance {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetBalance];
}

// 充值
+ (NSString *)pathUrlForCharge {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCharge];
}

// 提现
+ (NSString *)pathUrlForwithDraw {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYWithDraw];
}

// 交易记录
+ (NSString *)pathUrlForTransaction {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYTransactions];
}

// 解锁资源
+ (NSString *)pathUrlForUnlockStatusWithId:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUnlockPublish(statusId)];
}

// 解锁微信
+ (NSString *)pathUrlForUnlockWechat:(NSString *)userId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetWechat(userId)];
}

// 发现页广告
+ (NSString *)pathUrlForGetFindAd {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetFindAd];
}

// 发现页-关注
+ (NSString *)pathUrlForCareStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetFollowStatus];
}

// 推荐
+ (NSString *)pathUrlForGetInviteStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetInviteStatus];
}

// 获取所有动态
+ (NSString *)pathUrlForGetAllMyStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAllMyStatus];
}

// 其他用户所有动态
+ (NSString *)pathUrlForGetOtherStatusWith:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYAllUserStatius(uid)];
}

+ (NSString *)pathUrlForGetStatusCommentListWith:(NSString *)statusId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYStatusCommentList(statusId)];
}

+ (NSString *)pathUrlForDownPics {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetDownPics];
}

+ (NSString *)pathUrlForGetRichList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetRichList];
}

+ (NSString *)pathUrlForGetMyWalletDetailInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetWalletDetailInfo];
}

+ (NSString *)pathUrlForGetPhotoCover {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetPhotoCover];
}

+ (NSString *)pathUrlForUploadToQiniu {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUploadToQiniu];
}

+ (NSString *)pathUrlForGetGiftList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetGiftList];
}

+ (NSString *)pathUrlForRewardWith:(NSString *)uid {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYRewardSomeone(uid)];
}

+ (NSString *)pathUrlForGetDiamindsCanExchangeCoinsNumber {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetDiamondsCanExchangeCoinsNumber];
}

+ (NSString *)pathUrlForGetVipTypes {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetVipTypes];
}

+ (NSString *)pathUrlForChargeVipWith:(NSString *)days {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChargeVipWith(days)];
}

+ (NSString *)pathUrlForGetEverydayTask {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetEverydayMission];
}

+ (NSString *)pathUrlForGetLongTask {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetLongMission];
}

+ (NSString *)pathUrlForShareUrl {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYShareGiftUrl];
}

+ (NSString *)pathUrlForYBYShareSuccess {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYShareSuccess];
}

+ (NSString *)pathUrlForChargeWithAlipay {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChargeVipAlipay];
}

+ (NSString *)pathUrlForChargeVipWithWechat {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChargeVipWechat];
}
+ (NSString *)pathUrlForChargeVipWithDiamonds {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChargeVipDiamonds];
}

+ (NSString *)pathUrlForMyVipInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetVipInfo];
}

+ (NSString *)pathUrlForRefreshLocation {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYRefreshUserLocation];
}

+ (NSString *)pathUrlForGetVipList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetVipList];
}

+ (NSString *)pathUrlForGetCahrgeList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetChargeList];
}

+ (NSString *)pathUrlForGetQiniuToken {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetQiniuUploadToken];
}

+ (NSString *)pathUrlForSignupWith:(NSString *)type {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSignUpWith(type)];
}

+ (NSString *)pathUrlForMoreNethot {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYNetHotDataMore];
}

+ (NSString *)pathUrlForGetMorePretty {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYPrettyGirlMore];
}

+ (NSString *)pathUrlForGetHdVideoList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYVideoPageHD];
}

+ (NSString *)pathUrlForGetVrVideoList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYVideoPageVR];
}


+ (NSString *)pathUrlForGetHomeMoreData {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYHomeDataMore];
}

+ (NSString *)pathUrlForAddressList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAddressList];
}

+ (NSString *)pathUrlForAddAddress {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYAddAddress];
}

+ (NSString *)pathUrlForUpdateAddress:(NSString *)addressId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUpdateaddressWith(addressId)];
}

+ (NSString *)pathUrlForCheckIsHasUserWith:(NSString *)uid
{
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCheckIsHasUserWithId(uid)];
}

+ (NSString *)pathUrlForGetMyToken {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetMyToken];
}

+ (NSString *)pathUrlForLoginWithToken {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLoginWithToken];
}

+ (NSString *)pathUrlForUblockVideoWith:(NSString *)videoId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUnlockVideoWithId(videoId)];
}

+ (NSString *)pathUrlForGetPersonNotification {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetNotificationsByDate];
}

+ (NSString *)pathUrlForGetSystemNotification {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetSystemNotificationWithDate];
}

+ (NSString *)pathUrlForGetSearchKeyword {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetSearchKeyword];
}

+ (NSString *)pathUrlForGetSystemNotificationbyList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetSystemList];
}

+ (NSString *)pathUrlForGetSharePicrures {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetShareCardPics];
}

+ (NSString *)pathUrlForSearchUsers {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSearchUsers];
}

+ (NSString *)pathUrlForSearchPuhlishs {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYsearchStatus];
}

+ (NSString *)pathUrlForGetOrderStatusWith:(NSString *)orderId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetTradeStatusWithID(orderId)];
}

+ (NSString *)pathUrlForCheckActiviyWithActivityId:(NSString *)activityId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCheckinActivityWithID(activityId)];
}

+ (NSString *)pathUrlForPayActivityWithId:(NSString *)activityId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYBuyActivityWithId(activityId)];
}

+ (NSString *)pathUrlForGetActivityDetailWithId:(NSString *)activityId {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetActivityDetailWithId(activityId)];
}

+ (NSString *)pathUrlForIAPChargeDiamonds {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYIAPChargeDiamond];
}

+ (NSString *)pathUrlForIAPChargeVIP {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYIAPChargeVip];
}

@end
