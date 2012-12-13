//
//  LKDAOTest.h
//  LKDBTest
//
//  Created by s c on 12-11-17.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import "LKDAOBase.h"

@interface LKDAOTest : LKDAOBase

@end
@interface LKModelTest : LKModelBase

@property(strong,nonatomic)NSString* name;
@property int age;
@property BOOL isGirl;
@property(strong,nonatomic)NSDate* date;
@property(strong,nonatomic)UIImage* image;
@property(strong,nonatomic)NSData* bytes;
@end


@interface LKDAOTest2 : LKDAOBase

@end
@interface LKModelTest2 : NSObject<LKModelBaseInteface>
@property(copy,nonatomic)NSString* primaryKey;//继承接口的话 要手动 添加primarykey 和rowid 属性
@property int rowid;

@property(strong,nonatomic)NSString* name;
@property int age;
@property BOOL isGirl;
@property(strong,nonatomic)NSDate* date;
@property(strong,nonatomic)UIImage* image;
@property(strong,nonatomic)NSData* bytes;
@property(strong,nonatomic)NSString* hahaah1;
@property(strong,nonatomic)NSString* hahaah2;
@property(strong,nonatomic)NSString* hahaah3;
@property(strong,nonatomic)NSString* hahaah4;
@property(strong,nonatomic)NSString* hahaah5;
@end