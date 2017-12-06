//
//  XFHomeCoreDataManager.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/26.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFHomeCoreDataManager.h"
#import "XFCoreDataManager.h"

@implementation XFHomeCoreDataManager


+ (instancetype)sharedInstance {
    
    static XFHomeCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[XFHomeCoreDataManager alloc] init];
        
    });
    return manager;
    
}

/**
 *  刷新灵感库数据
 *
 *  @param data 请求到的数据
 *
 *  @return 返回新增的数据
 */
- (NSArray *)saveNewDataWith:(NSArray *)data name:(NSString *)name {
    
    [self deleteDataForName:name];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < data.count; i ++ ) {
        
        NSDictionary *dic = data[i];
        
        NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:kXFCoreDataManager.managedObjectContext];
        
        [obj modelSetWithDictionary:dic];
        
        [array addObject:obj];
    }
    
    [kXFCoreDataManager save];
    
    return array.copy;
    
    }
/**
 *  保存新的已完成项目数据
 *
 *  @param data 请求到的数据
 *
 *  @return 返回新增的数据
 */
- (NSArray *)saveMoreDataWith:(NSArray *)data name:(NSString *)name {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < data.count; i ++ ) {
        
        NSDictionary *dic = data[i];
        
        NSManagedObject *pro = [NSEntityDescription insertNewObjectForEntityForName:@"XFProject" inManagedObjectContext:kXFCoreDataManager.managedObjectContext];
        
        [pro modelSetWithDictionary:dic];
        
        [array addObject:pro];
    }
    
    [kXFCoreDataManager save];
    
    return array.copy;
    
}

- (void)deleteDataForName:(NSString *)name {
    
    NSArray *datas = [self fetchDataWithName:name];
    
    for (NSManagedObject *pro in datas) {
        
        [kXFCoreDataManager.managedObjectContext deleteObject:pro];
    }
    
    [kXFCoreDataManager save];
    
}

- (NSArray *)fetchDataWithName:(NSString *)name {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:name];
    
    return [kXFCoreDataManager.managedObjectContext executeFetchRequest:request error:nil];
    
}
/**
 *  删除数据
 *
 *  @param proId 项目ID
 */
- (void)deleteModelWithId:(NSString *)proId name:(NSString *)name {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"XFProject"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"id like %@",proId];
    
    NSArray *result = [kXFCoreDataManager.managedObjectContext executeFetchRequest:request error:nil];
    
    NSManagedObject *project = result[0];
    
    [kXFCoreDataManager.managedObjectContext deleteObject:project];
    
    [kXFCoreDataManager save];
    
}

@end
