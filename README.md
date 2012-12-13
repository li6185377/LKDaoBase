LKDaoBase
=========

automation database operation 根据绑定的实体类对数据库自动操作(增,删,改,查)

对于每个实体 几乎是 0操作   你不用再一行行 写插入 修改 删除的 代码了  定义完 属性 你就完事。 表也是自动创建的
示例代码:

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

   NSMutableDictionary* dic = [NSMutableDictionary dictionary];  
   [dic setObject:@"tamei" forKey:@"name"];  
   [dao searchWhereDic:dic orderBy:nil offset:0 count:15 callback:^(NSArray* array){  
       NSLog(@"\n 查询完的数据 \n : %d",array.count);  
       for (LKModelTest* model in array) {  
           NSLog(@"model{%@}",model);  
       }  
   }];  
