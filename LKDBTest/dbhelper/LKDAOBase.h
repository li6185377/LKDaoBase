//
//  LKDALBase.h
//  CarDaMan
//
//  Created by y h on 12-10-8.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

#define LKSQLText @"text"
#define LKSQLInt @"integer"
#define LKSQLDouble @"real"
#define LKSQLBlob @"blob"
#define LKSQLNull @"null"
#define LKSQLIntPrimaryKey @"integer primary key"

@interface NSObject(LKGetPropertys)
+(NSDictionary*)getPropertys; //返回 该类的所有属性 不上溯到 父类
+(void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes isGetSuper:(BOOL)isGetSuper;//获取自身的属性 是否获取父类
@end


//使用借口继承 来当 实体  要手动添加下面两个属性
@protocol LKModelBaseInteface <NSObject>
@property(copy,nonatomic)NSString* primaryKey;//主键名称 如果没有rowid 则跟据此名称update 和delete
@property int rowid;  //数据库的 rowid
@end

@interface LKModelBase : NSObject<LKModelBaseInteface>
@property(copy,nonatomic)NSString* primaryKey;
@property int rowid;
+(NSDictionary*)getPropertys; //还回 该类的所有属性 会添加父类属性
@end



@interface LKDAOBase : NSObject
-(id)initWithDBQueue:(FMDatabaseQueue*)queue;
@property(retain,nonatomic)FMDatabaseQueue* bindingQueue;
@property(retain,nonatomic)NSMutableDictionary* propertys;  //绑定的model属性集合
@property(retain,nonatomic)NSMutableArray* columeNames; //列名
@property(retain,nonatomic)NSMutableArray* columeTypes; //列类型

//清除创建表的历史记录
+(void)clearCreateHistory;
//返回表名  所有 Dao 都必须重载此方法
+(const NSString*)getTableName;

//返回绑定的Model Class
+(Class)getBindingModelClass;

-(void)addColume:(NSString*)name type:(NSString*)type;
-(void)addColumePrimary:(NSString *)name type:(NSString *)type;

//返回 create table parameter 语句
-(NSString*)getParameterString;

//创建数据库
-(void)createTable;

//默认返回 15条数据
-(void)searchAll:(void(^)(NSArray*))callback;

//默认返回 15条数据   where 条件 要自己写  比如 where =  @"rowid = 2"
-(void)searchWhere:(NSString*)where callback:(void(^)(NSArray*))block;

//基本sql语句
-(void)searchWhere:(NSString*)where orderBy:(NSString*)columeName offset:(int)offset count:(int)count callback:(void(^)(NSArray*))block;

//查询的条件以 key-value 模式传入
-(void)searchWhereDic:(NSDictionary*)where callback:(void(^)(NSArray*))block;
-(void)searchWhereDic:(NSDictionary*)where orderBy:(NSString *)orderby offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block;


//把 model 插入到 数据库
-(void)insertToDB:(NSObject<LKModelBaseInteface>*)model callback:(void(^)(BOOL))block;
-(void)updateToDB:(NSObject<LKModelBaseInteface>*)model callback:(void(^)(BOOL))block;
-(void)deleteToDB:(NSObject<LKModelBaseInteface>*)model callback:(void(^)(BOOL))block;
//根据where 条件删除数据
-(void)deleteToDBWithWhere:(NSString*)where callback:(void (^)(BOOL))block;
-(void)deleteToDBWithWhereDic:(NSDictionary*)where callback:(void (^)(BOOL))block;
//当 NSDictionary 的value 是NSArray 类型时  使用 or 当中间值

//清空表数据
-(void)clearTableData;

-(void)isExistsModel:(NSObject<LKModelBaseInteface>*)model callback:(void(^)(BOOL))block;
+(NSString*)toDBType:(NSString*)type; //把Object-c 类型 转换为sqlite 类型
@end

@interface NSString(LKisEmpty)
-(BOOL)isEmptyWithTrim;
-(NSString*)stringWithTrim;
@end

@interface LKDBPathHelper : NSObject
+(NSString*) getDocumentPath;
+(NSString*) getDirectoryForDocuments:(NSString*) dir;
+(NSString*) getPathForDocuments:(NSString*)filename;
+(NSString*) getPathForDocuments:(NSString *)filename inDir:(NSString*)dir;
+(BOOL) isFileExists:(NSString*)filepath;
@end