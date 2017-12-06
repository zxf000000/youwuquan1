//
//  XFHomeCoreDataManager.h
//  HuiShang
//
//  Created by mr.zhou on 2017/9/26.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFHomeCoreDataManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  刷新灵感库数据
 *
 *  @param data 请求到的数据
 *
 *  @return 返回新增的数据
 */
- (NSArray *)saveNewDataWith:(NSArray *)data name:(NSString *)name;
/**
 *  保存新的已完成项目数据
 *
 *  @param data 请求到的数据
 *
 *  @return 返回新增的数据
 */
- (NSArray *)saveMoreDataWith:(NSArray *)data name:(NSString *)name;

- (NSArray *)fetchDataWithName:(NSString *)name;
/**
 *  删除数据
 *
 *  @param proId 项目ID
 */
- (void)deleteModelWithId:(NSString *)proId name:(NSString *)name;
/**
 *  获取其他数据
 */
- (NSArray *)saveNewOtherData:(NSArray *)datas;


@end
