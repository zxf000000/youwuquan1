//
//  XFNetWorkApiTool.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/11.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFNetWorkApiTool : NSObject

/**
 获取所有标签

 @return 地址
 */
+ (NSString *)pathUrlForGetAlltags;


/**
 注册

 */
+ (NSString *)pathUrlForRegist;

/**
 登录
 */
+ (NSString *)pathUrlForLogin;
/**
 *  修改密码
 */
+ (NSString *)pathUrlForChangePwd;



/**
 获取验证码
 */
+ (NSString *)pathUrlForGetCode;

/**
 token登录

 @return 地址
 */
+ (NSString *)pathUrlForLoginWithToken;

/**
 保存用户信息

 @return 地址
 */
+ (NSString *)pathUrlForSaveUserInfo;

/**
 保存角色

 @return 地址
 */
+ (NSString *)pathUrlForSaveRole;

/**
 获取用户信息

 @return 地址
 */
+ (NSString *)pathUrlForGetUserInfo ;


/**
 保存标签

 @return 地址
 */
+ (NSString *)pathUrlForSaveLabel;

/**
 更细用户信息

 @return 地址
 */
+ (NSString *)pathUrlForUpdateUserinfo;

/**
 退出登录

 @return 地址
 */
+ (NSString *)pathUrlForLogout;


/**
 保存用户头像

 @return 地址
 */
+ (NSString *)pathUrlForSaveUserIcon;

//------------------------------------------- 可爱的分割线 --------------------------------------//

/**
 获取我的动态

 @return 地址
 */
+ (NSString *)pathUrlForGetMyStatus;

/**
 关注/取关

 @return 地址
 */
+ (NSString *)pathUrlForFollowSomeone;

/**
 我的发布
 */
+ (NSString *)pathUrlForMyPublish;

/**
 我的相册
 */
+ (NSString *)pathUrlForMyPhotos;

/**
 发布

 @return 地址
 */
+ (NSString *)pathUrlForPublish;

/**
 动态广场

 @return 地址
 */
+ (NSString *)pathUrlForStatusSqure;

/**
 推荐的动态

 @return url
 */
+ (NSString *)pathUrlForInviteStatus;

/**
 关注的动态
 */
+ (NSString *)pathUrlForCareStatus;

/**
 动态详情
 */
+ (NSString *)pathUrlForStatusDetail;

/**
 相册Id
 */
+ (NSString *)pathUrlForAlbumId;

/**
 点赞
 */
+ (NSString *)pathUrlForLikeSomeone;

/**
 评论
 */
+ (NSString *)pathUrlForCommentSomeone;

/**
 上传照片墙
 */
+ (NSString *)pathUrlForUploadImgToWall;

//------------------------------------------- 可爱的分割线 --------------------------------------//

/**
 技能列表
 */
+ (NSString *)pathUrlForSkillList;
/**
 更改技能
 */
+ (NSString *)pathUrlForCHangeSkill;

/**
 邀请某人
 */
+ (NSString *)pathUrlForInviteSomeOne;

/**
 获取邀约信息
 */
+ (NSString *)pathUrlForGetInviteInfo;

//------------------------------------------- 可爱的分割线 --------------------------------------//


/**
 充值
 */
+ (NSString *)pathUrlForCharge;

/**
 打赏
 */
+ (NSString *)pathUrlForReward;
/**
 解锁动态
 */
+ (NSString *)pathUrlForUnlockStatus;

/**
 签到
 */
+ (NSString *)pathUrlForsignUp;

/**
 获取每日任务数据
 */
+ (NSString *)pathUrlForGetDayMissionData;

/**
 每月签到数据
 */
+ (NSString *)pathUrlForGetMonthSingData;

/**
 获取用户昵称或头像
 */
+ (NSString *)pathUrlForGetUserNameIcon;

@end
