//
//  XFCoreDataManager.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/21.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFCoreDataManager.h"




@interface XFCoreDataManager ()

//iOS9中 CoreData Stack核心的三个类
//管理模型文件上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext1;
//模型文件
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
//存储调度器
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
//iOS10中NSPersistentContainer
/**
 CoreData Stack容器
 内部包含：
 管理对象上下文：NSManagedObjectContext *viewContext;
 对象管理模型：NSManagedObjectModel *managedObjectModel
 存储调度器：NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */
@property(nonatomic,strong)NSPersistentContainer *persistentContainer;


@end

@implementation XFCoreDataManager

+ (XFCoreDataManager *)sharedManager {

    static XFCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        manager = [[XFCoreDataManager alloc] init];
        
        
    });
    return manager;
}

#pragma mark -iOS10 CoreData Stack

//懒加载NSPersistentContainer
- (NSPersistentContainer *)persistentContainer
{
    if(_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //1.创建对象管理模型
    //    //根据某个模型文件路径创建模型文件
    //    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //2.创建NSPersistentContainer
    /**
     * name:数据库文件名称
     */
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"hsData" managedObjectModel:model];
    
    //3.加载存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * description, NSError * error) {
        NSLog(@"%@",description);
        NSLog(@"%@",error);
    }];
    return _persistentContainer;
}

#pragma mark - NSManagedObjectContext

//重写get方法
- (NSManagedObjectContext *)managedObjectContext
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0)
    {
        return kXFCoreDataManager.managedObjectContext1;
    }
    else
    {
        return kXFCoreDataManager.persistentContainer.viewContext;
    }
}

- (NSPersistentContainer *)getCurrentPersistentContainer
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0)
    {
        return nil;
    }
    else
    {
        return kXFCoreDataManager.persistentContainer;
    }
}

#pragma mark - ios10之前

//懒加载managedObjectContext
-(NSManagedObjectContext*)managedObjectContext1
{
    if (_managedObjectContext1 != nil) {
        return _managedObjectContext1;
    }
    
    //参数表示线程类型  NSPrivateQueueConcurrencyType比NSMainQueueConcurrencyType略有延迟
    _managedObjectContext1 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext1 setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext1;
}


//懒加载persistentStoreCoordinator
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //根据模型文件创建存储调度器
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    /**
     *  给存储调度器添加存储器
     *
     *  tyep:存储类型
     *  configuration：配置信息 一般为nil
     *  options：属性信息  一般为nil
     *  URL：存储文件路径
     */
    
    NSURL *url = [[self getDocumentsUrl] URLByAppendingPathComponent:@"person.db" isDirectory:YES];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
//    NSLog(@"%@",_persistentStoreCoordinator.persistentStores[0].URL);
    
    return _persistentStoreCoordinator;
    
}

-(NSURL*)getDocumentsUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}


//懒加载managedObjectModel
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //    //根据某个模型文件路径创建模型文件
    //    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
    
}

- (void)save
{
    
    NSError *error = nil;
    [kXFCoreDataManager.managedObjectContext save:&error];
    
    if (error == nil) {
        NSLog(@"保存到数据库成功");
    }
    else
    {
        NSLog(@"保存到数据库失败：%@",error);
    }
}


@end
