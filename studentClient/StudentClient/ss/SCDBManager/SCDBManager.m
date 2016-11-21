//
//  SCDBManager.m
//  SCGlobalProject
//
//  Created by user on 15/5/12.
//  Copyright (c) 2015年 tousan. All rights reserved.
//

#import "SCDBManager.h"

@implementation SCDBManager
{
    FMDatabase *db;
    FMStatement *fm_state;
}

+ (SCDBManager*)shareInstance;
{
    static SCDBManager *manager;
    if (manager==nil)
    {
        manager = [[SCDBManager alloc]init];
    }
    return manager;
}

#pragma mark - 配置数据库单例队列
+(FMDatabaseQueue *)shareDatabaseQueue
{
    static FMDatabaseQueue *my_FMDatabaseQueue=nil;
    
    if (!my_FMDatabaseQueue) {
        NSString *path = nil;
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.db"];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return my_FMDatabaseQueue;
}

- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        NSString *path = nil;
            //已经更新了地址数据库
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.db"];

        db = [[FMDatabase alloc]initWithPath:path];
        fm_state = [[FMStatement alloc] init];
    }
    return self;
}

- (void)createTableWithName:(NSString *)tableName keyArr:(NSArray *)keyArr;
{
    /*
    [db open];
    NSMutableString *commandStr = [[NSMutableString alloc]initWithFormat:@"create table if not exists %@",tableName];
    for (int i=0; i<keyArr.count; i++)
    {
        if (i==0)
        {
            [commandStr appendFormat:@"(%@ primary key",keyArr[i]];
            if (keyArr.count==1)
            {
                [commandStr appendFormat:@")"];
            }
        }
        else if (i!=keyArr.count-1)
        {
            [commandStr appendFormat:@",%@",keyArr[i]];
        }
        else
        {
            [commandStr appendFormat:@",%@)",keyArr[i]];
        }
    }
    if ([db executeUpdate:commandStr])
    {
        NSLog(@"%@",[NSString stringWithFormat:@"create table %@ success!",tableName]);
    }
    else
    {
        NSLog(@"%@",[NSString stringWithFormat:@"create table %@ failed!",tableName]);
    }
    [db close];
     */
    FMDatabaseQueue *queue = [SCDBManager shareDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSMutableString *commandStr = [[NSMutableString alloc]initWithFormat:@"create table if not exists %@",tableName];
            for (int i=0; i<keyArr.count; i++)
            {
                if (i==0)
                {
                    [commandStr appendFormat:@"(%@ primary key",keyArr[i]];
                    if (keyArr.count==1)
                    {
                        [commandStr appendFormat:@")"];
                    }
                }
                else if (i!=keyArr.count-1)
                {
                    [commandStr appendFormat:@",%@",keyArr[i]];
                }
                else
                {
                    [commandStr appendFormat:@",%@)",keyArr[i]];
                }
            }
            if ([db executeUpdate:commandStr])
            {
                NSLog(@"%@",[NSString stringWithFormat:@"create table %@ success!",tableName]);
            }
            else
            {
                NSLog(@"%@",[NSString stringWithFormat:@"create table %@ failed!",tableName]);
            }
            [db close];
        }
        else
        {
            NSLog(@"数据库打开失败!");
        }
    }];
}

- (void)dropTableWithName:(NSString*)tableName;
{
    [db open];
    if ([db executeUpdate:[NSString stringWithFormat:@"drop table %@",tableName]])
    {
        NSLog(@"%@",[NSString stringWithFormat:@"drop table %@ success!",tableName]);
    }
    else
    {
        NSLog(@"%@",[NSString stringWithFormat:@"drop table %@ failed!",tableName]);
    }
    [db close];
}

- (BOOL)insertIntoTable:(NSString*)tableName Values:(id)value,...;
{
    [db open];
    
    NSMutableString *commandStr = [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
    va_list list;
    NSMutableArray *valueArr = [[NSMutableArray alloc]init];
    if (value)
    {
        va_start(list, value);
        NSString *curStr = value;
        do
        {
            if (([curStr isKindOfClass:[NSNull class]])||(curStr==nil))
            {
                break;
            }
            else
            {
                if ([curStr isKindOfClass:[NSDictionary class]]||[curStr isKindOfClass:[NSArray class]])
                {
                    curStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:curStr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                }
                else
                {
                    curStr = [NSString stringWithFormat:@"%@",curStr];
                }
                [valueArr addObject:curStr];
            }
        }while ((curStr = va_arg(list, id)));
        va_end(list);
    }
    
    for (int i=0; i<valueArr.count; i++)
    {
        if (i==0)
        {
            [commandStr appendString:@"(?"];
            if (valueArr.count==1)
            {
                [commandStr appendString:@")"];
            }
        }
        else if (i==valueArr.count-1)
        {
            [commandStr appendString:@",?)"];
        }
        else
        {
            [commandStr appendString:@",?"];
        }
    }
    
    if (![db executeUpdate:commandStr withArgumentsInArray:valueArr])
    {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
    else
    {
        NSLog(@"insert success!");
        [db close];
        return YES;
    }
}

//插入多条记录到数组
//tableName : 表名
//dicArr    : 字典数组
//columnArr : 要插入的列名称
- (void)insertIntoTable:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block BOOL isSuccess = YES;
        NSMutableString *sql =  [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
        NSDictionary *dic = [dicArr firstObject];
        for (int i = 0; i < dic.count ; i++) {
            if (i==0)
            {
                [sql appendString:@"(?"];
                if (dic.count==1)
                {
                    [sql appendString:@")"];
                }
            }
            else if (i==dic.count-1)
            {
                [sql appendString:@",?)"];
            }
            else
            {
                [sql appendString:@",?"];
            }
        }
        
        NSMutableArray *valueArr = nil;
        
        int i = 0;
        
        for (NSDictionary *dic in dicArr) {
            
            valueArr = [NSMutableArray array];
            
            for (NSString *columnName in columnArr) {
                
                NSString *curStr = dic[columnName];
                
                if ([curStr isKindOfClass:[NSDictionary class]]||[curStr isKindOfClass:[NSArray class]])
                {
                    curStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:curStr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                }
                else
                {
                    curStr = [NSString stringWithFormat:@"%@",curStr];
                }
                
                [valueArr appendObject:curStr];
            }
            
            [[SCDBManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
                NSLog(@"thread ==> %d",[[NSThread currentThread ] isMainThread]);
                if ([db open]) {
                    
                    if (![db executeUpdate:sql withArgumentsInArray:valueArr])
                    {
                        NSLog(@"insert failed!");
                        isSuccess = NO;
                    }
                    else
                    {
                        //                    NSLog(@"insert success!");
                    }
                    
                    [db close];
                }
                else
                {
                    
                }
            }];

            i++;
        }
    });
}

- (void)updateTable:(NSString*)tableName setDic:(NSDictionary *)dic WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [db open];
    
    NSMutableArray *setArr = [NSMutableArray array];
    for (NSString *key in dic) {
        [setArr addObject:[NSString stringWithFormat:@"%@=%@",key,dic[key]]];
    }
    
    NSString *setStr = [setArr componentsJoinedByString:@","];
    
    if (![db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@ = ?",tableName,setStr,locateKey],locateValue])
    {
        NSLog(@"update failed!");
    }
    else
    {
        NSLog(@"update success!");
    }
    [db close];
}

- (void)deleteFromTable:(NSString*)tableName TargetKey:(NSString*)targetKey TargetValue:(id)targetValue;
{
    [db open];
    if (([targetValue isKindOfClass:[NSNull class]])||(targetValue==nil))
    {
        return;
    }
    else
    {
        if (![targetValue isKindOfClass:[NSString class]])
        {
            targetValue = [NSString stringWithFormat:@"%@",targetValue];
        }
    }
    if (![db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,targetKey,targetValue]])
    {
        NSLog(@"delete failed!");
    }
    else
    {
        NSLog(@"delete success!");
    }
    [db close];
}

- (void)updateTable:(NSString*)tableName SetTargetKey:(NSString*)targetKey WithValue:(id)targetValue WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [db open];
    if ([targetValue isKindOfClass:[NSDictionary class]]||[targetValue isKindOfClass:[NSArray class]])
    {
        targetValue = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:targetValue options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    NSString *str = [NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%@'",tableName,targetKey,targetValue,locateKey,locateValue];
    if (![db executeUpdate:str])
    {
        NSLog(@"update failed!");
    }else{
        NSLog(@"update success!");
    }
    [db close];
}

- (void)updateTable:(NSString*)tableName TargetKeys:(NSArray *)targetKeys TargetValues:(NSArray *)targetValues WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [db open];
    
    if (!targetKeys || !targetValues || !locateKey || !locateValue) {
        NSLog(@"参数有空值!");
        return;
    }
    
    if (targetKeys.count != targetValues.count) {
        NSLog(@"key和value个数不匹配!");
        return;
    }
    
    NSMutableArray *setArr = [NSMutableArray array];
    int i = 0;
    for (NSString *key in targetKeys) {
        NSString *value = targetValues[i];
        [setArr addObject:[NSString stringWithFormat:@"%@='%@'",key,value]];
//        if ([value isKindOfClass:[NSString class]]?!isEmptyStr(value):YES) {
//            [setArr addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
//        }
        i++;
    }
    
    NSString *setStr = [setArr componentsJoinedByString:@","];
    
//    NSString *str = [NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '@'",tableName,setStr,locateKey,locateValue];
   
    if (![db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@ = ?",tableName,setStr,locateKey],locateValue])
    {
        NSLog(@"update failed!");
    }
    else
    {
        NSLog(@"update success!");
    }
    [db close];
}

- (void)updateTableThree:(NSString*)tableName TargetKeys:(NSArray *)targetKeys TargetValues:(NSArray *)targetValues WhereItsKey:(NSString*)key1 IsValue:(id)value1 key:(NSString *)key2 values:(id)value2 key:(NSString *)key3 values:(id)value3;
{
    [db open];
    
//    if (!targetKeys || !targetValues || !locateKey || !locateValue) {
//        NSLog(@"参数有空值!");
//        return;
//    }
    
    if (targetKeys.count != targetValues.count) {
        NSLog(@"key和value个数不匹配!");
        return;
    }
    
    NSMutableArray *setArr = [NSMutableArray array];
    int i = 0;
    for (NSString *key in targetKeys) {
        NSString *value = targetValues[i];
        [setArr addObject:[NSString stringWithFormat:@"%@='%@'",key,value]];
        i++;
    }
    
    NSString *setStr = [setArr componentsJoinedByString:@","];
    
    NSString *str = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@' or %@ = '%@' and %@ = '%@'",tableName,setStr,key1,value1,key2,value2,key3,value3];
    
    if (![db executeUpdate:str])
    {
        NSLog(@"update failed!");
    }
    else
    {
        NSLog(@"update success!");
    }
    [db close];
}


- (id)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue TargetKey:(NSString*)targetKey;
{
    [db open];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    id targetValue;
    while ([result next])
    {
        targetValue = [result stringForColumn:targetKey];
    }
    [result close];
    [db close];
    return targetValue;
}

//获取表中一条记录，以字典返回
- (NSDictionary *)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue columnArr:(NSArray *)columnArr;
{
    [db open];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    while ([result next])
    {
        for (int i = 0; i < columnArr.count; i++) {
             [dic setObject:[result stringForColumn:columnArr[i]] forKey:columnArr[i]];
        }
    }
    [result close];
    [db close];
    return dic;
}

- (NSArray *)getAllValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

- (NSArray *)getAllNOValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ != ?",tableName,locateKey],locateValue];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

- (NSArray*)getAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr;
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

- (void)getAllObjectsFromTable:(NSString *)table keyArr:(NSArray*)keyArr completionBlock:(void(^)(NSArray *array))block
{
    [[SCDBManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSMutableArray *elementArr = [[NSMutableArray alloc]init];
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
            while ([result next])
            {
                NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
                for (int i=0; i<keyArr.count; i++)
                {
                    [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
                }
                [elementArr addObject:elementDic];
            }
            [db close];
            block(elementArr);
        }
        else
        {
            NSLog(@"database open failed!");
        }
    }];
}

- (NSArray*)getCrossAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr WhereItsKey:(NSString*)key1 IsValue:(id)value1 andkey:(NSString *)key2 value:(id)value2;
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    NSString *str = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%@'",table,key1,value1,key2,value2];
    FMResultSet *result = [db executeQuery:str];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

- (NSArray*)getNOCrossAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr WhereItsNOKey:(NSString*)key1 IsNOValue:(id)value1 andkey:(NSString *)key2 value:(id)value2;
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    NSString *str = [NSString stringWithFormat:@"select * from %@ where %@ != '%@' and %@ = '%@'",table,key1,value1,key2,value2];
    FMResultSet *result = [db executeQuery:str];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

- (NSArray*)submitGetAllObjectsFromTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)key1 IsValue:(id)value1 key:(NSString *)key2 value:(id)value2
{
    [db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
//    if (![locateValue isKindOfClass:[NSString class]])
//    {
//        locateValue = [locateValue stringValue];
//    }
    NSString *str = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%@'",tableName,key1,value1,key2,value2];
    FMResultSet *result = [db executeQuery:str];
    //    id targetValue;
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        NSString * valueStr = [[NSString alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            NSMutableArray * mutKeyArr = [keyArr mutableCopy];
            //            NSLog(@"~~%@~~",mutKeyArr[i]);
            if ([mutKeyArr[i] isEqualToString:@"end_time_hour"]) {
                valueStr = [result stringForColumn:mutKeyArr[i]];
                mutKeyArr[i] = @"endTime";
                [elementDic setObject:valueStr forKey:mutKeyArr[i]];
            }else if ([mutKeyArr[i] isEqualToString:@"start_time_hour"]){
                valueStr = [result stringForColumn:mutKeyArr[i]];
                mutKeyArr[i] = @"startTime";
                [elementDic setObject:valueStr forKey:mutKeyArr[i]];
            }else if ([mutKeyArr[i] isEqualToString:@"classId"]) {
                if ([[result stringForColumn:mutKeyArr[i]] isEqualToString:@"1"]) {
                    valueStr = @"C1";
                }else if ([[result stringForColumn:mutKeyArr[i]] isEqualToString:@"2"]){
                    valueStr = @"C2";
                }
                [elementDic setObject:valueStr forKey:mutKeyArr[i]];
            }else{
                [elementDic setObject:[result stringForColumn:mutKeyArr[i]] forKey:mutKeyArr[i]];
            }
            
        }
        [elementArr addObject:elementDic];
    }
    [db close];
    return elementArr;
}

+ (id)stringToObject:(NSString*)string;
{
    if (string==nil)
    {
        string = @"";
    }
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

/** Indication of whether the statement is in use */
- (BOOL)isInUse
{
    return fm_state.inUse;
}

@end
