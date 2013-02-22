//
//  LKDAOTest.m
//  LKDBTest
//
//  Created by s c on 12-11-17.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import "LKDAOTest.h"

@implementation LKDAOTest
+(Class)getBindingModelClass
{
    return [LKModelTest class];
}
+(NSString *)getTableName
{
    return @"lktable";
}
@end

@implementation LKModelTest
- (id)init
{
    self = [super init];
    if (self) {
        self.primaryKey = @"name";
    }
    return self;
}

@end
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
- (id)init
{
    self = [super init];
    if (self) {
        self.primaryKey = @"name";
    }
    return self;
}
@end