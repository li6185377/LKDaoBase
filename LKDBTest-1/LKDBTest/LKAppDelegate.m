//
//  LKAppDelegate.m
//  LKDBTest
//
//  Created by s c on 12-11-17.
//  Copyright (c) 2012年 LK. All rights reserved.
//


#import "LKAppDelegate.h"
#import "LKDAOTest.h"
#import "LKDBHelper.h"
@implementation LKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = [[UIViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    
    LKDAOTest2* dao = [LKDAOTest2 sharedDao];
    
    LKModelTest2* model = [[LKModelTest2 alloc]init]; 
    [dao clearTableData];//清空表数据
    
    model.name = @"nimei";
    model.age = 16;
    model.isGirl = YES;
    model.date = [NSDate date];
    model.image = [UIImage imageNamed:@"110.png"];
    model.bytes = [@"aaaaaabbbbbbcccccc" dataUsingEncoding:NSUTF8StringEncoding];
    
    [model printAllPropertys];
    
    //采用同步方式
    
    //插入
    BOOL result = [dao insertToDB:model];
    if(result)
    {
        NSLog(@"插入成功");
    }
    //搜索
    LKModelTest2* test = [[dao searchWhere:nil orderBy:nil offset:0 count:1] objectAtIndex:0];
    [test printAllPropertys];
    test.name = @"哈哈哈";
    
    result = [dao updateToDB:test where:nil];
    if(result)
    {
        NSLog(@"更新成功");
    }
    test = [[dao searchWhere:nil orderBy:nil offset:0 count:1] objectAtIndex:0];
    [test printAllPropertys];
    
    //采用 异步回调的方式  进行数据库操作

    [dao insertToDB:model callback:nil];
    
    model.name = @"womei";
    [dao insertToDB:model callback:nil];  //可一直 插入
    
    model.name = @"tamei";
    [dao insertToDB:model callback:^(BOOL nono){
        NSLog(@"数据 插入 结果:%d",nono);
        NSLog(@"插入结束");
    }];
    
    //查询
    [dao searchWhereDic:nil orderBy:@"name,rowid desc,age" offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"开始查询 \n 数据%d条 \n : ",array.count);
        for (LKModelTest2* model in array) {
            [model printAllPropertys];
        }
    }];
    
   
    [dao rowCount:^(int count) {
         NSLog(@" 行数查询:\n 数据%d条 \n : ",count);
    } where:nil];
    
    
    [dao rowCount:^(int count) {
        NSLog(@"行数条件查询: \n 数据%d条 \n : ",count);
    } where:@{@"name":@"tamei"}];
    
    //条件查询
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"tamei" forKey:@"name"];
    
    //一个key 多条件用 NSArray
    NSArray* selectnames =[NSArray arrayWithObjects:@"tamei",@"womei", nil];
    [dic setObject:selectnames forKey:@"name"];
    [dic setObject:@"16" forKey:@"age"];
    
    [dao searchWhereDic:dic orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n条件查询:\n");
        for (LKModelTest2* model in array) {
            NSLog(@" rowid %d name : %@  \n",model.rowid,model.name);
        }
    }];
    
    //更新   如果有 更新primary 列的值 最好rowid 有值 不然会更新失败 或者错乱
    model.name = @"haishi nimei";
    [dao updateToDB:model where:nil];
    //如果  要更新 primary的 值  而且  不知道 他的 rowid
    
    model.rowid = -1;
    model.name = @"haishi womei"; //更新了 primary 列上的值  如果 这时候用默认更新就会失败  所有要我们自己加条件
    [dao updateToDB:model where:@"name = 'womei'" callback:^(BOOL yes) {
        NSLog(@"更新结果:%d\n",yes);
    }];
    
    //or 使用     NSDictionary  当条件
    
    NSMutableDictionary* dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@[@"nimei",@"womei"] forKey:@"name"];
    [dao updateToDB:model where:dic2 callback:nil];
    
    
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 更新完的数据 \n : %d",array.count);
        for (LKModelTest2* model in array) {
            NSLog(@"rowid %d name : %@",model.rowid,model.name);
        }
    }];
    
    //删除
    [dao deleteToDB:model callback:nil];
    
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 删除完的数据 \n : %d",array.count);
        for (LKModelTest2* model in array) {
            NSLog(@"%@",model);
        }
    }];
    
    //根据条件删除
    NSMutableDictionary* deleteDic = [NSMutableDictionary dictionary];
//    NSMutableArray* names = [NSMutableArray arrayWithObjects:@"nimei",@"womei",nil];
    [deleteDic setObject:@"haishi nimei" forKey:@"name"];
    [dao deleteToDBWithWhereDic:deleteDic callback:nil];
    
    
    //最终结果
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 删除完的数据 \n : %d",array.count);
        for (LKModelTest2* model in array) {
            NSLog(@"name : %@",model.name);
        }
    }];

    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
