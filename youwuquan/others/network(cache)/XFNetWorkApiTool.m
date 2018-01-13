//
//  XFNetWorkApiTool.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/11.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFNetWorkApiTool.h"


#define YBYHost @"http://47.95.38.122:82/yby/"
//#define YBYHost @"http://192.168.2.100:8088/yby/"

// 获取验证码
#define YBYGetCode @"login/obtainVcNum?"
// 注册
#define YBYRegist @"login/userRegister?"
// 登录
#define YBYLogin @"login/userLogin?"
// 更改密码
#define YBYChangePwd @"login/resetPsw?"
// token登录
#define YBYLoginWithToken @"login/userLoginByToken?"
// 保存用户信息
#define YBYSaveUserInfo @"userDetails/saveOrUpdateUserDetails?"
// 保存角色
#define YBYSaveRole @"role/saveRole?"
// 获取用户详情
#define YBYGEtUserInfo @"userDetails/queryUserDetails?"
// 保存标签
#define YBYSaveLabel @"label/saveLabel?"
// 修改用户详情
#define YBYUpdateUserInfo @"userDetails/updateUserDetails?"
// 退出登录
#define YBYLogout @"login/signOut?"
// 保存头像
#define YBYsaveUserIcon @"image/headImagesUpload?"
// 获取所有技能
#define YBYGetAllSkills @"skill/querySkillList?"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 动态
#define YBYGetMyStatus @"moment/myMoment"
// 关注或取消关注
#define YBYFollowSomeone(para) @"moment/()/attention"
// 我的发布
#define YBYMyPublish @"album/myRelease"
// 我的相册
#define YBYMyPhotos @"album/myAlbum"
// 发布
#define YBYPublish @"moment/release"
// 动态广场
#define YBYStatusSquare @"moment/momentsSquare"
// 推荐动态
#define YBYInviteStatus @"moment/momentsRecommend"
// 关注动态
#define YBYCareStatus @"moment/momentsAttention"
// 动态详情
#define YBYStatusDetail @"moment/momentDetails"
// 公开/私密相册的Id
#define YBYGetMyPhotoAlumId @"album/getAlbumId"
// 点赞
#define YBYLikeSomeone @"moment/goGreat"
// 评论
#define YBYCommentSomeone @"moment/goMessage"
// 获取标签
#define YBYGetAllLabels @"moment/getLabel"

// 上传照片墙
#define YBYUploadImgToWall @"moment/photoWall"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 获取技能列表
#define YBYGetSkillList @"skill/queryUserSkillList?"
// 激活或者修改邀约的技能
#define YBYChangeSkill @"skill/openOrUpdateSkill?"
// 通过制定技能邀约用户
#define YBYInviteSomeone @"invite/invitationUser?"
// 获取被邀约用户的所有信息
#define YBYGetInvitedBodyInfo @"invite/queryInviteList?"
// 邀请注册页面
#define YBYGetInvitePage @"invite/queryInviteList?"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 获取融云token
#define YBYGetRongToken @"ronguser/getRongToken"
// 获取用户昵称和头像
#define YBYGetUSernameIcon @"ronguser/getUserNickAndHeadUrl"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 充值钻石
#define YBYChargeDiamond @"property/rechargeDiamonds?"
// 打赏
#define YBYReward @"property/reward?"
// 解锁动态
#define YBYUnlockStatus @"property/unlockMoment"

// 获取账户信息
#define YBYGetMyMoneyINfo @"property/account?"
// 提现
#define YBYCash @"withdrawals/withdrawals?"
// 认证
#define YBYAuth @"property/attestation?"

//------------------------------------------- 可爱的分割线 --------------------------------------//
// 签到
#define YBYSingUp @"sign/goSign"
// 获取每月签到数据
#define YBYGetSingData @"sign/getSignDataFromMonth"
// 获取用户每日任务数据
#define YBYGetDayMissionData @"task/findTaskByUserNo"


@implementation XFNetWorkApiTool : NSObject

+ (NSString *)pathUrlForRegist {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYRegist];
}

+ (NSString *)pathUrlForLogin {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLogin];
}


+ (NSString *)pathUrlForChangePwd {
    
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChangePwd];

}

+ (NSString *)pathUrlForGetCode {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetCode];
}

+ (NSString *)pathUrlForLoginWithToken {
    
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLoginWithToken];
}

+ (NSString *)pathUrlForSaveUserInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSaveUserInfo];
}

+ (NSString *)pathUrlForSaveRole {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSaveRole];
}

+ (NSString *)pathUrlForGetUserInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGEtUserInfo];
}


+ (NSString *)pathUrlForSaveLabel {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSaveLabel];
}

+ (NSString *)pathUrlForUpdateUserinfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUpdateUserInfo];
}

+ (NSString *)pathUrlForLogout {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLogout];
}


+ (NSString *)pathUrlForSaveUserIcon {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYsaveUserIcon];
}

// 获取标签
+ (NSString *)pathUrlForGetAlltags {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAllLabels];
    
}

+ (NSString *)pathUrlForGetMyStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetMyStatus];
}

+ (NSString *)pathUrlForFollowSomeone {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYFollowSomeone(@"")];
}

+ (NSString *)pathUrlForMyPublish {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYMyPublish];
}

+ (NSString *)pathUrlForMyPhotos {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYMyPhotos];
}

+ (NSString *)pathUrlForPublish {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYPublish];
}

+ (NSString *)pathUrlForStatusSqure {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYStatusSquare];
}

+ (NSString *)pathUrlForInviteStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYInviteStatus];
}

+ (NSString *)pathUrlForCareStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCareStatus];
}

+ (NSString *)pathUrlForStatusDetail {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYStatusDetail];
}

+ (NSString *)pathUrlForAlbumId {
    
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetMyPhotoAlumId];
}

+ (NSString *)pathUrlForLikeSomeone {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYLikeSomeone];
}

+ (NSString *)pathUrlForCommentSomeone {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCommentSomeone];
}

+ (NSString *)pathUrlForUploadImgToWall {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUploadImgToWall];
}


//------------------------------------------- 可爱的分割线 --------------------------------------//
+ (NSString *)pathUrlForSkillList {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetSkillList];
}

+ (NSString *)pathUrlForCHangeSkill {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChangeSkill];
}

+ (NSString *)pathUrlForInviteSomeOne {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYInviteSomeone];
}

+ (NSString *)pathUrlForGetInviteInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetInvitedBodyInfo];
}

//------------------------------------------- 可爱的分割线 --------------------------------------//
+ (NSString *)pathUrlForCharge {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYChargeDiamond];
}

+ (NSString *)pathUrlForReward {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYReward];
}

+ (NSString *)pathUrlForUnlockStatus {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYUnlockStatus];
}

+ (NSString *)pathUrlForGetUserNameIcon {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetUSernameIcon];
}



+ (NSString *)pathUrlForsignUp {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYSingUp];
}

+ (NSString *)pathUrlForGetDayMissionData {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetDayMissionData];
}

+ (NSString *)pathUrlForGetMonthSingData {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetSingData];
}

+ (NSString *)pathUrlForGetAllSkills {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetAllSkills];
}

//------------------------------------------- 可爱的分割线 --------------------------------------//

+ (NSString *)pathUrlForGetMyMoneyInfo {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYGetMyMoneyINfo];
}

+ (NSString *)pathUrlForCash {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYCash];
}

+ (NSString *)pathUrlForAuth {
    
    return [NSString stringWithFormat:@"%@%@",YBYHost,YBYAuth];
}




@end
