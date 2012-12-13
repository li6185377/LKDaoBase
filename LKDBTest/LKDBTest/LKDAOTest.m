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
const static NSString* tablename = @"lktable";
+(const NSString *)getTableName
{
    return tablename;
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
const static NSString* tablename2 = @"lktable2";
+(const NSString *)getTableName
{
    return tablename2;
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