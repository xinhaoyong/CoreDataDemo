//
//  ViewController.m
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "ViewController.h"
#import "Preson+CoreDataClass.h"
#import "Uid+CoreDataClass.h"
#import "CoreDataManager.h"
#import <objc/runtime.h>
@interface ViewController ()<NSFetchedResultsControllerDelegate>
{
    NSArray *arr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //增

    for (int i = 0 ; i < 10; i ++) {
        Uid *uid = [XCoreDataManager insertModelWithEntityName:@"Uid"];
        uid.uid = [NSString stringWithFormat:@"1991121%d",i];
        
        Preson *preson;
        preson = [XCoreDataManager insertModelWithEntityName:@"Preson"];
        preson.name = [NSString stringWithFormat:@"xhy%d",i];
        preson.height = 176.0;
        preson.weight = 74.0;
        preson.uid = uid;
        
    }
     [XCoreDataManager save];
    
    NSArray *arr = [XCoreDataManager FindModelWithEntityName:@"Preson" andPredicate:[NSPredicate predicateWithFormat:@"uid.uid == 19911210"]];
    Preson *preson = [arr lastObject];
    
//改
    NSArray *o = [XCoreDataManager FindModelWithEntityName:@"Uid"];
    for (int i = 0; i < o.count; i++) {
        Uid *uid = o[i];
        [uid setValue:[NSString stringWithFormat:@"%d",i] forKey:@"uid"];
    }
    [XCoreDataManager save];

    
//删
    NSArray *objs = [XCoreDataManager FindModelWithEntityName:@"Uid"];

    for (int i = 0; i < objs.count; i++) {
        Uid *uid = objs[i];
        [XCoreDataManager.managedObjectContext deleteObject:uid];
    }
    
    NSArray *objs1 = [XCoreDataManager FindModelWithEntityName:@"Preson"];
    for (int i = 0; i < objs1.count; i++) {
        Preson *preson = objs1[i];
        [XCoreDataManager.managedObjectContext deleteObject:preson];
        NSLog(@"delect Preson ----- %d",i);
    }
    
    [XCoreDataManager save];

//查
    NSArray *objs2 = [XCoreDataManager FindModelWithEntityName:@"Uid"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
