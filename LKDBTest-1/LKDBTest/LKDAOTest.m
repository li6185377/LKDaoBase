//
//  LKDAOTest.m
//  LKDBTest
//
//  Created by s c on 12-11-17.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import "LKDAOTest.h"


@implementation LKDAOTest2
+(Class)getBindingModelClass
{
    return [LKModelTest2 class];
}
+(NSString *)getTableName
{
    return @"lktable2";
}
@end
@implementation LKModelTest2
+(NSString *)primaryKey
{
    return @"name";
}
@end