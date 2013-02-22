//
//  LKDBHelper.m
//  upin
//
//  Created by upin on 12-12-6.
//  Copyright (c) 2012年 linggan. All rights reserved.
//

#import "LKDBHelper.h"
@interface LKDBHelper()
@property(retain,nonatomic)FMDatabaseQueue* queue;
@property(copy,nonatomic)NSString* dbname;
@end
@implementation LKDBHelper
+(LKDBHelper *)sharedDBHelper
{
    static LKDBHelper* dbhelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbhelper = [[self alloc]init];
    });
    return dbhelper;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self setDBName:@"LKDB"];
    }
    return self;
}
-(void)setDBName:(NSString *)name
{
    if([self.dbname isEqualToString:name] == NO)
    {
        if(! [name hasSuffix:@".db"])
        {
            self.dbname = [NSString stringWithFormat:@"%@.db",name];
        }
        else
        {
            self.dbname = name;
        }
        [self.queue close];
        self.queue = [[FMDatabaseQueue alloc]initWithPath:[LKDBPathHelper getPathForDocuments:name inDir:@"db"]];
    }
}
-(FMDatabaseQueue *)getFMDBQueue
{
    return self.queue;
}
-(void)dropAllTable
{
    [self.queue inDatabase:^(FMDatabase* db){
       FMResultSet* set = [db executeQuery:@"select name from sqlite_master where type='table'"];
        NSMutableArray* dropTables = [NSMutableArray arrayWithCapacity:0];
        while ([set next]) {
            [dropTables addObject:[set stringForColumnIndex:0]];
        }
        [set close];
        for (NSString* tableName in dropTables) {
            NSString* dropTable = [NSString stringWithFormat:@"drop table %@",tableName];
            [db executeUpdate:dropTable];
        }
    }];
}
-(void)dealloc
{
    [self.queue close];
    self.queue = nil;
    self.dbname = nil;
    
}
@end

@implementation LKDAOBase(LKSharedDao)
+(id)sharedDao
{
    static NSMutableDictionary* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSMutableDictionary alloc]initWithCapacity:8];
    });
    NSString* className = NSStringFromClass([self class]);
    @synchronized(instance)
    {
        LKDAOBase* dao = [instance objectForKey:className];
        if(dao == nil)
        {
            dao = [[self alloc]initWithDBQueue:[[LKDBHelper sharedDBHelper] getFMDBQueue]];
            [instance setObject:dao forKey:className];
        }
        return dao;
    }
}
-(void)rowcountWithWhere:(NSString *)where callback:(void (^)(int))callback
{
    [self.bindingQueue inDatabase:^(FMDatabase* db){
        NSString* rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ where %@",[self.class getTableName],where];
        FMResultSet* resultSet = [db executeQuery:rowCountSql];
        [resultSet next];
        int result =  [resultSet intForColumnIndex:0];
        [resultSet close];
        callback(result);
    }];
}
@end
