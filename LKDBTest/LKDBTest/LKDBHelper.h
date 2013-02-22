//
//  LKDBHelper.h
//  upin
//
//  Created by upin on 12-12-6.
//  Copyright (c) 2012年 linggan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "LKDaobase.h"

@interface LKDBHelper : NSObject
+(LKDBHelper*)sharedDBHelper;
-(void)setDBName:(NSString*)name;
-(FMDatabaseQueue*)getFMDBQueue;
-(void)dropAllTable;
@end
//自己又扩展了下 LKDaobase 使每个子类都采用单例
@interface LKDAOBase(LKSharedDao)
+(id)sharedDao;
-(void)rowcountWithWhere:(NSString*)where callback:(void(^)(int))callback;
@end