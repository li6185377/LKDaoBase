//
//  LKAppDelegate.m
//  LKDBTest
//
//  Created by s c on 12-11-17.
//  Copyright (c) 2012年 LK. All rights reserved.
//


#import "LKAppDelegate.h"
#import "LKDAOTest.h"
static FMDatabaseQueue* queue;
@implementation LKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = [[UIViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    queue = [[FMDatabaseQueue alloc]initWithPath:[LKDBPathHelper getPathForDocuments:@"test.db" inDir:@"db"]];
    
    LKDAOTest2* dao = [[LKDAOTest2 alloc]initWithDBQueue:queue];

    LKModelTest2* model = [[LKModelTest2 alloc]init]; //  使用接口实现类 来当 实体  如果属性相同  可互相替换

    [dao clearTableData];//清空表数据
    
    model.name = @"nimei";
    model.age = 16;
    model.isGirl = YES;
    model.date = [NSDate date];
    model.image = [UIImage imageNamed:@"110.png"];
    model.bytes = [@"aaaaaabbbbbbcccccc" dataUsingEncoding:NSUTF8StringEncoding];

    [dao insertToDB:model callback:nil];

    model.name = @"womei";
    [dao insertToDB:model callback:nil];  //可一直 插入
    
    model.name = @"tamei";
    [dao insertToDB:model callback:^(BOOL nono){
        NSLog(@"insert %d",nono);
    }];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"tamei" forKey:@"name"];
    [dao searchWhereDic:dic orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 查询完的数据 \n : %d",array.count);
        for (LKModelTest* model in array) {
            NSLog(@"model{%@}",model);
        }
    }];
    
    NSArray* selectnames =[NSArray arrayWithObjects:@"tamei",@"womei", nil];
    [dic setObject:selectnames forKey:@"name"];
    [dic setObject:@"16" forKey:@"age"];
    [dao searchWhereDic:dic orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 查询完的数据 \n : %d",array.count);
        for (LKModelTest* model in array) {
            NSLog(@"model{%@}",model);
        }
    }];
    
    
    
    model.name = @"haishi nimei";
    [dao updateToDB:model callback:nil];
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 更新完的数据 \n : %d",array.count);
        for (LKModelTest* model in array) {
            NSLog(@" name : %@",model.name);
        }
    }];
    
    [dao deleteToDB:model callback:nil];
    
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 删除完的数据 \n : %d",array.count);
        for (LKModelTest* model in array) {
            NSLog(@"%@",model);
        }
    }];
    
    //根据条件删除
    NSMutableDictionary* deleteDic = [NSMutableDictionary dictionary];
//    NSMutableArray* names = [NSMutableArray arrayWithObjects:@"nimei",@"womei",nil];
    [deleteDic setObject:@"womei" forKey:@"name"];
    [dao deleteToDBWithWhereDic:deleteDic callback:nil];
    
    [dao searchWhere:nil orderBy:nil offset:0 count:15 callback:^(NSArray* array){
        NSLog(@"\n 删除完的数据 \n : %d",array.count);
        for (LKModelTest* model in array) {
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
