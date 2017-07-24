//
//  Uid+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by kings on 2017/7/19.
//  Copyright © 2017年 kings. All rights reserved.
//

#import "Uid+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Uid (CoreDataProperties)

+ (NSFetchRequest<Uid *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, retain) Preson *presons;

@end

NS_ASSUME_NONNULL_END
