//
//  CoreDataManager.m
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "CoreDataManager.h"
#import <UIKit/UIKit.h>
#define CLASS_NAME(PRAM) NSStringFromClass([PRAM class])
#import <objc/runtime.h>

@interface CoreDataManager ()
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

@implementation CoreDataManager

+ (CoreDataManager *)shareInstance
{
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc] init];
    });
    return manager;
}

#pragma mark -iOS9 CoreData Stack

//获取沙盒路径URL
-(NSURL*)getDocumentsUrl
{
    NSURL *pathstr = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSLog(@"iOS10 CoreData存储路径%@",pathstr);
    
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
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *url = [[self getDocumentsUrl] URLByAppendingPathComponent:@"person.db" isDirectory:YES];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:optionsDictionary error:nil];
    
    NSLog(@"%@",_persistentStoreCoordinator.persistentStores[0].URL);
    
    return _persistentStoreCoordinator;
    
}

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
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"sql.db" managedObjectModel:model];
    
    //3.加载存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * description, NSError * error) {
        NSLog(@"iOS10 CoreData存储路径%@",description);
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
        return self.managedObjectContext1;
    }
    else
    {
        return self.persistentContainer.viewContext;
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
        return self.persistentContainer;
    }
}

- (BOOL)save
{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error == nil) {
        NSLog(@"保存到数据库成功");
        return YES;
    }
    else
    {
        NSLog(@"保存到数据库失败：%@",error);
        return NO;
    }
}

-(id)insertModelWithEntityName:(NSString *)name{
    id something = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:XCoreDataManager.managedObjectContext];
    return something;
}

-(NSArray *)FindModelWithEntityName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:XCoreDataManager.managedObjectContext];
    request.entity = desc;
    NSError *error = nil;
    NSArray *objs = [XCoreDataManager.managedObjectContext executeFetchRequest:request error:&error];
    return objs;
}
-(NSArray *)FindModelWithEntityName:(NSString *)name andPredicate:(NSPredicate *)predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:XCoreDataManager.managedObjectContext];
    request.entity = desc;
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [XCoreDataManager.managedObjectContext executeFetchRequest:request error:&error];
    return objs;
}

@end
