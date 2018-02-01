//
//  XFMineNetworkManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/2.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MineRequestSuccessBlock)(id responseObj);
typedef void(^MineRequestFailedBlock)(NSError *error);
typedef void(^MineRequestProgressBlock)(CGFloat progress);

@interface XFMineNetworkManager : NSObject

/**
 获取所有标签

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getAllTagsWithSuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 关注标签

 @param tags 标签(逗号隔开)
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)followTagsWithTags:(NSString *)tags
              successBlock:(MineRequestSuccessBlock)successBlock
               failedBlock:(MineRequestFailedBlock)failedBlock
             progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 设置自己的标签

 @param tags 标签
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)setTagsWithTags:(NSString *)tags
           successBlock:(MineRequestSuccessBlock)successBlock
            failedBlock:(MineRequestFailedBlock)failedBlock
          progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取所有信息

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getAllInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 更新用户信息

 @param birthday 生日
 @param height 身高
 @param weight 体重
 @param bust 胸围
 @param waist 腰围
 @param hip 臀围
 @param starsign 星座
 @param introduce 介绍
 @param wechat 微信
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)updateUserInfoWithBirthday:(NSString *)birthday
                            height:(NSString *)height
                            weight:(NSString *)weight
                              bust:(NSString *)bust
                             waist:(NSString *)waist
                               hip:(NSString *)hip
                          starSign:(NSString *)starsign
                         introduce:(NSString *)introduce
                            wechat:(NSString *)wechat
                          nickname:(NSString *)nickname
                      successBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 上传头像

 @param icon 头像
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)uploadIconWithImage:(UIImage *)icon
               successBlock:(MineRequestSuccessBlock)successBlock
                failedBlock:(MineRequestFailedBlock)failedBlock
              progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取其他人信息

 @param uid userId
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getOtherInfoWithUid:(NSString *)uid
               successBlock:(MineRequestSuccessBlock)successBlock
                failedBlock:(MineRequestFailedBlock)failedBlock
              progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取认证信息列表

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getDefineListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 查看自己的认证信息

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyDefinesWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 上传认证信息

 @param name 姓名
 @param phone 手机
 @param wechat 微信
 @param email 邮箱
 @param idCardNum 身份证
 @param notes 备注
 @param createTime 时间
 @param frontImage 正面身份证
 @param backImage 杯面
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)updateDefineInfoWith:(NSString *)name
                       phone:(NSString *)phone
                      wechat:(NSString *)wechat
                       email:(NSString *)email
                   idCardNum:(NSString *)idCardNum
                       notes:(NSString *)notes
                  createTime:(NSString *)createTime
                  frontImage:(UIImage *)frontImage
                   backImage:(UIImage *)backImage
                    defineId:(NSInteger )defineId
                successBlock:(MineRequestSuccessBlock)successBlock
                 failedBlock:(MineRequestFailedBlock)failedBlock
               progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取认证信息

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getDefineInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 用户照片墙

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyPhotoWallInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                               failedBlock:(MineRequestFailedBlock)failedBlock
                             progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 上传照片墙

 @param images 图片
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)uploadPhotoWallWithImages:(NSArray *)images
                     successBlock:(MineRequestSuccessBlock)successBlock
                      failedBlock:(MineRequestFailedBlock)failedBlock
                    progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 删除照片墙

 @param pics 图片(,隔开)
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)deletePhotoWallWithPics:(NSString *)pics
                   successBlock:(MineRequestSuccessBlock)successBlock
                    failedBlock:(MineRequestFailedBlock)failedBlock
                  progressBlock:(MineRequestProgressBlock)progressBlock;
/**
 查看其它用户照片墙

 @param userId uid
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getOtherPhotoWallWithUserId:(NSString *)userId
                       successBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取公开相册

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyOpenPhotoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                           failedBlock:(MineRequestFailedBlock)failedBlock
                         progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取私密相册

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyClosePhotoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 查看自己粉丝列表

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyFansListWithPage:(NSInteger)page rows:(NSInteger)rows successBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 查看自己的关注列表

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyCaresWithPage:(NSInteger)page rows:(NSInteger)rows successBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 下载相册

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyDownloadPicsWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 关注某人

 @param uid id
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)careSomeoneWithUid:(NSString *)uid
              successBlock:(MineRequestSuccessBlock)successBlock
               failedBlock:(MineRequestFailedBlock)failedBlock
             progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 取消关注

 @param uid uid
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)unCareSomeoneWithUid:(NSString *)uid
                successBlock:(MineRequestSuccessBlock)successBlock
                 failedBlock:(MineRequestFailedBlock)failedBlock
               progressBlock:(MineRequestProgressBlock)progressBlock;
/**
 用户喜欢默认

 @param uid id
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)likeSomeoneWithId:(NSString *)uid
             successBlock:(MineRequestSuccessBlock)successBlock
              failedBlock:(MineRequestFailedBlock)failedBlock
            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 用户取消喜欢某人
 
 @param uid id
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)unlikeSomeoneWithId:(NSString *)uid
             successBlock:(MineRequestSuccessBlock)successBlock
              failedBlock:(MineRequestFailedBlock)failedBlock
            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 我的钱包

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyWalletDataWithSuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 充值

 @param number 数量
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)chargeWithNumber:(NSString *)number
                    type:(NSString *)type
            successBlock:(MineRequestSuccessBlock)successBlock
             failedBlock:(MineRequestFailedBlock)failedBlock
           progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 提现申请

 @param number 数量
 @param method 方式
 @param payId id
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)txWithNumber:(NSString *)number
              method:(NSString *)method
               payId:(NSString *)payId
                name:(NSString *)name
        successBlock:(MineRequestSuccessBlock)successBlock
         failedBlock:(MineRequestFailedBlock)failedBlock
       progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 交易记录

 @param page 页数
 @param size 行数
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getTranscationsWithPage:(NSString *)page
                           size:(NSString *)size
                   successBlock:(MineRequestSuccessBlock)successBlock
                    failedBlock:(MineRequestFailedBlock)failedBlock
                  progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 查看账户详细信息

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyWalletDetailWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 富豪榜

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getRichListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取相册封面

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getPhototCoverWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取可以兑换多少金币

 @param diamonds 钻石
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getCoinsNumForDiamonds:(NSInteger)diamonds
                  successBlock:(MineRequestSuccessBlock)successBlock
                   failedBlock:(MineRequestFailedBlock)failedBlock
                 progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 兑换金币
 
 @param diamonds 钻石
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)exchangeCoinsNumForDiamonds:(NSInteger)diamonds
                  successBlock:(MineRequestSuccessBlock)successBlock
                   failedBlock:(MineRequestFailedBlock)failedBlock
                 progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取vip列表

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getVipListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 充值vip

 @param days 天数
 @param successBlock 陈宫
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)chargeVipWithDays:(NSString *)days
             successBlock:(MineRequestSuccessBlock)successBlock
              failedBlock:(MineRequestFailedBlock)failedBlock
            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取充值列表

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getChargeListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取每日任务

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getEverydayTaskWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock;

/**
获取长期任务

@param successBlock 成功
@param failedBlock 失败
@param progressBlock 进度
*/
+ (void)getLongTaskWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取分享链接

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getShareUrlWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 分享成功调用

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)shareSuccessWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 支付宝购买vip

 @param days 天数
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)buyVipWithAlipayWithDays:(NSInteger)days
                    successBlock:(MineRequestSuccessBlock)successBlock
                     failedBlock:(MineRequestFailedBlock)failedBlock
                   progressBlock:(MineRequestProgressBlock)progressBlock;
/**
 微信购买vip
 
 @param days 天数
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)buyVipWithWechatWithDays:(NSInteger)days
                    successBlock:(MineRequestSuccessBlock)successBlock
                     failedBlock:(MineRequestFailedBlock)failedBlock
                   progressBlock:(MineRequestProgressBlock)progressBlock;
/**
 钻石购买vip
 
 @param days 天数
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)buyVipWithDiamondsWithDays:(NSInteger)days
                    successBlock:(MineRequestSuccessBlock)successBlock
                     failedBlock:(MineRequestFailedBlock)failedBlock
                   progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取vip信息

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyVipInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 检查app更新

 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)checkUpdateForAppWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取地址列表

 @param successBlock 0
 @param failedBlock 0
 @param progressBlock 0
 */
+ (void)getAddressListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                           failedBlock:(MineRequestFailedBlock)failedBlock
                         progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 添加地址

 @param uid uid
 @param province 省份
 @param city 城市
 @param detail 详细
 @param postcode 右边
 @param phone 电话
 @param successBlock 0
 @param failedBlock 0
 @param progressBlock 0
 */
+ (void)addAddressWithName:(NSString *)name
                 province:(NSString *)province
                     city:(NSString *)city
                   detail:(NSString *)detail
                 postcode:(NSString *)postcode
                    phone:(NSString *)phone
             successBlock:(MineRequestSuccessBlock)successBlock
              failedBlock:(MineRequestFailedBlock)failedBlock
            progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 添加地址
 
 @param uid uid
 @param province 省份
 @param city 城市
 @param detail 详细
 @param postcode 右边
 @param phone 电话
 @param successBlock 0
 @param failedBlock 0
 @param progressBlock 0
 */
+ (void)updateAddressWithId:(NSInteger)addressId
                        name:(NSString *)name
                   province:(NSString *)province
                       city:(NSString *)city
                     detail:(NSString *)detail
                   postcode:(NSString *)postcode
                      phone:(NSString *)phone
               successBlock:(MineRequestSuccessBlock)successBlock
                failedBlock:(MineRequestFailedBlock)failedBlock
              progressBlock:(MineRequestProgressBlock)progressBlock;


/**
 获取分享背景图

 @param successBlock 0
 @param failedBlock 0
 @param progressBlock 0
 */
+ (void)getSharePicWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock;

/**
 获取订单状态

 @param orderId oid
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getTradeStatusWithOrderId:(NSString *)orderId
                     successBlock:(MineRequestSuccessBlock)successBlock
                      failedBlock:(MineRequestFailedBlock)failedBlock
                    progressBlock:(MineRequestProgressBlock)progressBlock;



@end
