//
//  MessageDataBase.m
//  学员端
//
//  Created by zuweizhong  on 16/8/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MessageDataBase.h"
#import <FMDatabase.h>
#import "FMDatabaseQueue.h"
@implementation MessageDataBase
{
    FMDatabaseQueue *queue;
}
#pragma mark - 实现类方法,单例方法
+ (instancetype)shareInstance
{
    static MessageDataBase *db = nil;
    @synchronized(self)
    {
        if (db == nil)
        {
            db = [[MessageDataBase alloc] init];
        }
    }
    return db;
}
-(instancetype)init
{
    if (self = [super init]) {
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"message.db"];
        
        HJLog(@"%@",destinationPath);
        
        queue = [FMDatabaseQueue databaseQueueWithPath:destinationPath];
        
        [queue inDatabase:^(FMDatabase *db) {
            
            NSString *sqlStr = @"CREATE TABLE if not exists messageTable(id INTEGER PRIMARY KEY AUTOINCREMENT,msg_id INTEGER NOT NULL,title varchar(100) NOT NULL,msg text NOT NULL ,addtime INTEGER NOT NULL,isRead tinyint(1) NOT NULL DEFAULT '0')";
            
            
            BOOL result = [db executeUpdate:sqlStr];
            if (!result)
            {
                NSLog(@"Create Error:%@",db.lastErrorMessage);
            }
            else
            {
                NSLog(@"Create successed!");
            }
            
        }];

        
    }
    return self;
    
}
-(void)insertDataWithModel:(MsgModel *)model
{
    [queue inDatabase:^(FMDatabase *db) {
        //sqlite3数据库replace如果主键相同，原数据删除，重新插入新数据，如果主键不相同则插入新数据
        NSString *sql = @"replace into messageTable(id,msg_id,title,msg,addtime,isRead) values(?,?,?,?,?,?)";
        BOOL result = [db executeUpdate:sql,@(model.idNum),@(model.msg_id),model.title,model.msg,@(model.addtime),@(model.isRead)];
        if (!result)
        {
            NSLog(@"插入失败------%@",db.lastErrorMessage);
        }
        else
        {
            NSLog(@"插入 successed!");
        }
        
        
    }];
    

    
}
-(void)setDataIsReadWithModel:(MsgModel *)model
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"UPDATE messageTable SET isRead =? WHERE id = ?";
        BOOL result = [db executeUpdate:sql,@(1),@(model.idNum)];
        if (!result)
        {
            NSLog(@"UPDATE 失败------%@",db.lastErrorMessage);
        }
        else
        {
            NSLog(@"UPDATE  successed!");
        }
        
    }];

}
-(MsgModel *)getMaxIdModel
{
    MsgModel *model = [[MsgModel alloc] init];

    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"SELECT * FROM messageTable ORDER BY id DESC LIMIT 1";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            NSString * title = [resultSet stringForColumn:@"title"];
            NSString * msg = [resultSet stringForColumn:@"msg"];
            int addtime = [resultSet intForColumn:@"addtime"];
            BOOL isRead = [resultSet boolForColumn:@"isRead"];
            int msg_id = [resultSet intForColumn:@"msg_id"];

            
            model.idNum = idNum;
            model.title = title;
            model.msg = msg;
            model.addtime = addtime;
            model.isRead = isRead;
            model.msg_id = msg_id;
            
        }
    }];
    
    return model;


}
-(NSArray *)queryCircleMessage
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  @"select * from messageTable where msg_id=13 ORDER BY id DESC ";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            MsgModel *model = [[MsgModel alloc] init];
            
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            NSString * title = [resultSet stringForColumn:@"title"];
            NSString * msg = [resultSet stringForColumn:@"msg"];
            int addtime = [resultSet intForColumn:@"addtime"];
            BOOL isRead = [resultSet boolForColumn:@"isRead"];
            int msg_id = [resultSet intForColumn:@"msg_id"];
            
            
            model.idNum = idNum;
            model.title = title;
            model.msg = msg;
            model.addtime = addtime;
            model.isRead = isRead;
            model.msg_id = msg_id;
            
            
            [array addObject:model];
        }
    }];
    return array;

}
-(NSArray *)queryCircleUnRead
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  @"select * from messageTable where msg_id=13 and isRead=0 ORDER BY id DESC ";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            MsgModel *model = [[MsgModel alloc] init];
            
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            NSString * title = [resultSet stringForColumn:@"title"];
            NSString * msg = [resultSet stringForColumn:@"msg"];
            int addtime = [resultSet intForColumn:@"addtime"];
            BOOL isRead = [resultSet boolForColumn:@"isRead"];
            int msg_id = [resultSet intForColumn:@"msg_id"];
            
            
            model.idNum = idNum;
            model.title = title;
            model.msg = msg;
            model.addtime = addtime;
            model.isRead = isRead;
            model.msg_id = msg_id;
            
            
            [array addObject:model];
        }
    }];
    return array;

}
-(NSArray *)queryAllUnRead
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  @"select * from messageTable where isRead=0 ORDER BY id DESC";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            MsgModel *model = [[MsgModel alloc] init];
            
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            NSString * title = [resultSet stringForColumn:@"title"];
            NSString * msg = [resultSet stringForColumn:@"msg"];
            int addtime = [resultSet intForColumn:@"addtime"];
            BOOL isRead = [resultSet boolForColumn:@"isRead"];
            int msg_id = [resultSet intForColumn:@"msg_id"];

            
            model.idNum = idNum;
            model.title = title;
            model.msg = msg;
            model.addtime = addtime;
            model.isRead = isRead;
            model.msg_id = msg_id;

            
            
            [array addObject:model];
        }
    }];
    return array;



}
-(NSArray *)query
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  @"select * from messageTable ORDER BY id DESC ";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            MsgModel *model = [[MsgModel alloc] init];

            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            NSString * title = [resultSet stringForColumn:@"title"];
            NSString * msg = [resultSet stringForColumn:@"msg"];
            int addtime = [resultSet intForColumn:@"addtime"];
            BOOL isRead = [resultSet boolForColumn:@"isRead"];
            int msg_id = [resultSet intForColumn:@"msg_id"];

            
            model.idNum = idNum;
            model.title = title;
            model.msg = msg;
            model.addtime = addtime;
            model.isRead = isRead;
            model.msg_id = msg_id;

            
            [array addObject:model];
        }
    }];
    return array;
    
}


@end
