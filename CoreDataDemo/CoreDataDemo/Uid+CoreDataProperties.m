//
//  Uid+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "Uid+CoreDataProperties.h"

@implementation Uid (CoreDataProperties)

+ (NSFetchRequest<Uid *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Uid"];
}

@dynamic uid;
@dynamic presons;

@end
