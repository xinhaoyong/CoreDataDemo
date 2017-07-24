//
//  Preson+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "Preson+CoreDataProperties.h"

@implementation Preson (CoreDataProperties)

+ (NSFetchRequest<Preson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Preson"];
}

@dynamic name;
@dynamic height;
@dynamic weight;
@dynamic uid;

@end
