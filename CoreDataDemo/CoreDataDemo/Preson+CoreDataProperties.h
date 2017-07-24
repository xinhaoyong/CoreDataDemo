//
//  Preson+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "Preson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Preson (CoreDataProperties)

+ (NSFetchRequest<Preson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float height;
@property (nonatomic) float weight;
@property (nullable, nonatomic, retain) Uid *uid;

@end

NS_ASSUME_NONNULL_END
