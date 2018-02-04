//
//  XFMineNetworkManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/2.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFMineNetworkManager.h"
#import "XFNetworking.h"
#import "XFApiClient.h"
#import <AFHTTPSessionManager.h>

@implementation XFMineNetworkManager

+ (void)getAllTagsWithSuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock {

    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetAllTag] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)followTagsWithTags:(NSString *)tags
              successBlock:(MineRequestSuccessBlock)successBlock
               failedBlock:(MineRequestFailedBlock)failedBlock
             progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"ids":tags};
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForFollowTags] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];

    
}

+ (void)setTagsWithTags:(NSString *)tags
           successBlock:(MineRequestSuccessBlock)successBlock
            failedBlock:(MineRequestFailedBlock)failedBlock
          progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"ids":tags};
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForSetTags] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getAllInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetAllUserInfo] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

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
                     progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (birthday)    [params setObject:birthday                 forKey:@"birthDay"];
    if (height)      [params setObject:@([height integerValue]) forKey:@"height"];
    if (weight)      [params setObject:@([weight doubleValue])  forKey:@"weight"];
    if (bust)        [params setObject:@([bust integerValue])   forKey:@"bust"];
    if (waist)       [params setObject:@([waist integerValue])  forKey:@"waist"];
    if (hip)         [params setObject:@([hip integerValue])    forKey:@"hip"];
    if (starsign)    [params setObject:starsign                 forKey:@"starSign"];
    if (introduce)   [params setObject:introduce                forKey:@"introduce"];
    if (wechat)      [params setObject:wechat                   forKey:@"wechat"];
    if (nickname)    [params setObject:nickname                 forKey:@"nickname"];
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForUpdateUserInfo] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
    
}

+ (void)uploadIconWithImage:(UIImage *)icon
               successBlock:(MineRequestSuccessBlock)successBlock
                failedBlock:(MineRequestFailedBlock)failedBlock
              progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking uploadFileWithUrl:[XFApiClient pathUrlForUpdateIcon] fileData:UIImageJPEGRepresentation(icon, 0.8) type:@"image" name:@"image" mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
        progressBlock(bytesWriten/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getOtherInfoWithUid:(NSString *)uid
               successBlock:(MineRequestSuccessBlock)successBlock
                failedBlock:(MineRequestFailedBlock)failedBlock
              progressBlock:(MineRequestProgressBlock)progressBlock {

    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetAllOtherInfo:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getDefineListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForAllDefineList] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getMyDefinesWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetMyDefine] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

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
               progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"name":name,
                             @"phone":phone,
                             @"wechat":wechat,
                             @"email":email,
                             @"idCardNum":idCardNum,
                             @"notes":notes,
                             @"identificationId":@(defineId)
                             };
    
    [XFNetworking uploadDefineFileWithUrl:[XFApiClient pathUrlForUpdefineInfo] fileData:@[UIImageJPEGRepresentation(frontImage, 0.2),UIImageJPEGRepresentation(backImage, 0.2)] type:@"image" name:@[@"frontImage",@"backImage"] mimeType:@"image/jpeg" params:params progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
        
        progressBlock(bytesWriten/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        failedBlock(error);
        
    }];
}

+ (void)getDefineInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForUpdefineInfo] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getMyPhotoWallInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                               failedBlock:(MineRequestFailedBlock)failedBlock
                             progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForPhotoWall] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)uploadPhotoWallWithImages:(NSArray *)images
                     successBlock:(MineRequestSuccessBlock)successBlock
                      failedBlock:(MineRequestFailedBlock)failedBlock
                    progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger i = 0 ; i < images.count ; i ++ ) {
        
        NSData *data = UIImageJPEGRepresentation(images[i], 0.01);
        [datas addObject:data];
        
    }
    
    [XFNetworking uploadMutableWithUrl:[XFApiClient pathUrlForAddPhotoWall] fileData:datas type:@"image" name:@"images" mimeType:@"image/jpeg" params:nil progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
        
        progressBlock(bytesWriten/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
//    [XFNetworking uploadMultFileWithUrl:[XFApiClient pathUrlForAddPhotoWall] fileDatas:datas type:@"image" name:@"images" mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWriten, int64_t totalBytes) {
//
//        progressBlock(bytesWriten/(CGFloat)totalBytes);
//
//    } successBlock:^(id response) {
//
//        successBlock(response);
//
//    } failBlock:^(NSArray *errors) {
//
//        failedBlock(nil);
//
//    }];
}

+ (void)getOtherPhotoWallWithUserId:(NSString *)userId
                       successBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGEtOtherWallWithId:[NSString stringWithFormat:@"%@",userId]] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        failedBlock(error);
        
    }];
}

+ (void)getMyOpenPhotoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                           failedBlock:(MineRequestFailedBlock)failedBlock
                         progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetMyOpenPhoto] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getMyClosePhotoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetClosePhoto] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getMyFansListWithPage:(NSInteger)page rows:(NSInteger)rows successBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"page":@(page),
                             @"size":@(rows),
                             };

    [XFNetworking getWithUrl:[XFApiClient pathUrlForMyFans] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getMyCaresWithPage:(NSInteger)page rows:(NSInteger)rows successBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"page":@(page),@"size":@(rows)};
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForFollows] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}


+ (void)getMyDownloadPicsWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForDownPics] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

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
             progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForFollowOtherWithId:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

// 取消关注
+ (void)unCareSomeoneWithUid:(NSString *)uid
              successBlock:(MineRequestSuccessBlock)successBlock
               failedBlock:(MineRequestFailedBlock)failedBlock
             progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForFollowOtherWithId:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

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
            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForLikeOther:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

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
              progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForLikeOther:uid] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}



/**
 我的钱包
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyWalletDataWithSuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetBalance] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
    
}




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
           progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"payMethod":type,
                             @"price":@([number doubleValue]),
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"text/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [manager POST:[XFApiClient pathUrlForCharge] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock(str);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failedBlock(error);

    }];
    
}

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
       progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"payMethod":method,
                             @"payId":payId,
                             @"accountName":name,
                             @"diamonds":number
                             };
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForwithDraw] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}


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
                  progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"page":page,
                             @"size":size
                             };
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForTransaction] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getRichListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetRichList] refreshRequest:YES cache:YES praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)getMyWalletDetailWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetMyWalletDetailInfo] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getPhototCoverWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                           failedBlock:(MineRequestFailedBlock)failedBlock
                         progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetPhotoCover] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}


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
                 progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"diamonds":@(diamonds)};
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetDiamindsCanExchangeCoinsNumber] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}
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
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"diamonds":@(diamonds)};
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForGetDiamindsCanExchangeCoinsNumber] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取vip列表
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getVipListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                       failedBlock:(MineRequestFailedBlock)failedBlock
                     progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetVipTypes] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}


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
            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForChargeVipWith:days] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
    
        failedBlock(error);
        
    }];
    
}

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
                  progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"ids":pics};
    [XFNetworking deleteWithUrl:[XFApiClient pathUrlForPhotoWall] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取每日任务
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getEverydayTaskWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                            failedBlock:(MineRequestFailedBlock)failedBlock
                          progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetEverydayTask] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取长期任务
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getLongTaskWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetLongTask] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取分享链接
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getShareUrlWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForShareUrl] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}


/**
 分享成功调用
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)shareSuccessWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking postWithUrl:[XFApiClient pathUrlForYBYShareSuccess] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

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
                   progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"day":@(days)};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"text/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [manager POST:[XFApiClient pathUrlForChargeWithAlipay] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock(str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
        
    }];
    
//
//    [XFNetworking postWithUrl:[XFApiClient pathUrlForChargeWithAlipay] refreshRequest:NO cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
//
//        progressBlock(bytesRead/(CGFloat)totalBytes);
//
//    } successBlock:^(id response) {
//
//        successBlock(response);
//
//    } failBlock:^(NSError *error) {
//
//        failedBlock(error);
//
//    }];
    
}
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
                   progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"day":@(days)};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"text/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [manager POST:[XFApiClient pathUrlForChargeVipWithWechat] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock(str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
        
    }];
    
//
//    [XFNetworking postWithUrl:[XFApiClient pathUrlForChargeVipWithWechat] refreshRequest:NO cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
//
//        progressBlock(bytesRead/(CGFloat)totalBytes);
//
//    } successBlock:^(id response) {
//
//        successBlock(response);
//
//    } failBlock:^(NSError *error) {
//
//        failedBlock(error);
//
//    }];
    
}
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
                     progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"day":@(days)};

    [XFNetworking postWithUrl:[XFApiClient pathUrlForChargeVipWithDiamonds] refreshRequest:NO cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取vip信息
 
 @param successBlock 成功
 @param failedBlock 失败
 @param progressBlock 进度
 */
+ (void)getMyVipInfoWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                         failedBlock:(MineRequestFailedBlock)failedBlock
                       progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForMyVipInfo] refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

+ (void)checkUpdateForAppWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                              failedBlock:(MineRequestFailedBlock)failedBlock
                            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSString *appId = @"1335528589";
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId];
    [XFNetworking postWithUrl:url refreshRequest:NO cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getChargeListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                          failedBlock:(MineRequestFailedBlock)failedBlock
                        progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetCahrgeList] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

/**
 获取地址列表
 
 @param successBlock 0
 @param failedBlock 0
 @param progressBlock 0
 */
+ (void)getAddressListWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                           failedBlock:(MineRequestFailedBlock)failedBlock
                         progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForAddressList] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}


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
            progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"name":name,
                             @"province":province,
                             @"city":city,
                             @"detail":detail,
                             @"postcode":postcode,
                             @"phone":phone
                             };
    [XFNetworking postWithUrl:[XFApiClient pathUrlForAddAddress] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
    
}

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
              progressBlock:(MineRequestProgressBlock)progressBlock {
    
    NSDictionary *params = @{@"id":@(addressId),
                             @"name":name,
                             @"province":province,
                             @"city":city,
                             @"detail":detail,
                             @"postcode":postcode,
                             @"phone":phone
                             };
    [XFNetworking putWithUrl:[XFApiClient pathUrlForUpdateAddress:[NSString stringWithFormat:@"%zd",addressId]] refreshRequest:YES cache:NO praams:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getSharePicWithsuccessBlock:(MineRequestSuccessBlock)successBlock
                        failedBlock:(MineRequestFailedBlock)failedBlock
                      progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetSharePicrures] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

+ (void)getTradeStatusWithOrderId:(NSString *)orderId
                     successBlock:(MineRequestSuccessBlock)successBlock
                      failedBlock:(MineRequestFailedBlock)failedBlock
                    progressBlock:(MineRequestProgressBlock)progressBlock {
    
    [XFNetworking getWithUrl:[XFApiClient pathUrlForGetOrderStatusWith:orderId] refreshRequest:YES cache:NO praams:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        progressBlock(bytesRead/(CGFloat)totalBytes);
        
    } successBlock:^(id response) {
        
        successBlock(response);
        
    } failBlock:^(NSError *error) {
        
        failedBlock(error);
        
    }];
}

@end
