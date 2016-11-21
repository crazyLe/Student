//
//  MistakeQuestionDataBase.m
//  学员端
//
//  Created by zuweizhong  on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MistakeQuestionDataBase.h"
#import <FMDatabase.h>
#import "FMDatabaseQueue.h"

@implementation MistakeQuestionDataBase
{
    FMDatabaseQueue *queue;
}
#pragma mark - 实现类方法,单例方法
+ (instancetype)shareInstance
{
    static MistakeQuestionDataBase *db = nil;
    @synchronized(self)
    {
        if (db == nil)
        {
            db = [[MistakeQuestionDataBase alloc] init];
        }
    }
    return db;
}
-(instancetype)init
{
    if (self = [super init]) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"exam_questions.db"];
        HJLog(@"%@",path);
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [queue inDatabase:^(FMDatabase *db) {
            
            NSString *sqlStr = @"CREATE TABLE if not exists mistake_questions(id INTEGER PRIMARY KEY AUTOINCREMENT,multi_radio tinyint(1) NOT NULL DEFAULT '1',name_bin varchar(100) NOT NULL,option varchar(100) NOT NULL ,answer text NOT NULL,test_answer_bin varchar(200) NOT NULL DEFAULT '',image_bin BLOB,type tinyint(1) NOT NULL DEFAULT '1',class_type varchar(255) NOT NULL DEFAULT '1',is_img tinyint(1) NOT NULL DEFAULT '0',error_rate REAL NOT NULL,addtime INTEGER NOT NULL,is_del tinyint(1) NOT NULL DEFAULT '0',chapter tinyint(1) NOT NULL DEFAULT '1',media_type tinyint(1) NOT NULL DEFAULT '1',mistakeType INTEGER NOT NULL)";
            
            
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
-(void)deleteAllSubject1Data
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from mistake_questions WHERE type = 1";
        BOOL result = [db executeUpdate:sql];
        if (!result)
        {
            NSLog(@"删除所有失败------%@",db.lastErrorMessage);
        }
        else
        {
            NSLog(@"删除所有 successed!");
        }
    }];
    
}
-(void)deleteAllSubject4Data
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from mistake_questions WHERE type = 4";
        BOOL result = [db executeUpdate:sql];
        if (!result)
        {
            NSLog(@"删除所有失败------%@",db.lastErrorMessage);
        }
        else
        {
            NSLog(@"删除所有 successed!");
        }
    }];

}
-(void)deleteDataWithModel:(ExamQuestionModel *)model
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from mistake_questions where id = ?";
        BOOL result = [db executeUpdate:sql,@(model.idNum)];
        if (!result)
        {
            HJLog(@"删除失败------%@",db.lastErrorMessage);
        }
        else
        {
            HJLog(@"删除 successed!");
        }
    }];
}
-(void)insertDataWithModel:(ExamQuestionModel *)model
{

    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"insert into mistake_questions(id,multi_radio,name_bin,option,answer,test_answer_bin,image_bin,type,class_type,is_img,error_rate,addtime,is_del,chapter,media_type,mistakeType) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        BOOL result = [db executeUpdate:sql,@(model.idNum),@(model.multi_radio),model.name_bin,model.option,model.answer,model.test_answer_bin,model.image_bin,@(model.type),model.class_type, @(model.is_img),@(model.err_rate),@(model.addtime),@(model.is_del),@(model.chapter),@(model.media_type),@(model.mistakeType)];
        //sqlite3数据库如果主键相同则不插入，主键相同原数据不更新，主键不相同插入
        if (!result)
        {
            HJLog(@"插入失败------%@",db.lastErrorMessage);
        }
        else
        {
            HJLog(@"插入 successed!");
        }
        
        
    }];



}
-(NSArray *)queryTestMistakeDataWithSubject:(NSString *)subject
{

    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        
//        NSString *sql =[NSString stringWithFormat:@"SELECT mistake_questions.*,errorRateTable.errorRate FROM mistake_questions left join errorRateTable on mistake_questions.id=errorRateTable.id WHERE type =%@ and  mistakeType = %d",subject,2];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM mistake_questions WHERE type=%@ and mistakeType = %d",subject,2];
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSString *name = [resultSet stringForColumn:@"name_bin"];
//            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
//            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", name);
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSString *test_answer_bin = [resultSet stringForColumn:@"test_answer_bin"];
//            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
//            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
//            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            int mistakeType = [resultSet intForColumn:@"mistakeType"];
            
            model.idNum = idNum;
            model.multi_radio = multi_radio;
            model.name_bin = name;
            model.option = option;
            model.answer = answer;
            model.test_answer_bin = test_answer_bin;
            model.err_rate = err_rate;
            model.type = type;
            model.class_type = class_type;
            model.media_type = media_type;
            model.is_img = is_img;
            model.addtime = addtime;
            model.is_del = is_del;
            model.chapter = chapter;
            model.image_bin = imgdata;
            model.mistakeType = mistakeType;
            
            [array addObject:model];
        }
    }];
    return array;


}
-(NSArray *)queryZuoTiMistakeDataWithSubject:(NSString *)subject
{


    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
//        NSString *sql =[NSString stringWithFormat:@"SELECT mistake_questions.*,errorRateTable.errorRate FROM mistake_questions left join errorRateTable on mistake_questions.id=errorRateTable.id WHERE type =%@ and  mistakeType = %d",subject,1];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM mistake_questions WHERE type=%@ and mistakeType = %d",subject,1];
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSString *name = [resultSet stringForColumn:@"name_bin"];
//            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
//            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", name);
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSString *test_answer_bin = [resultSet stringForColumn:@"test_answer_bin"];

//            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
//            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
//            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
//            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            int mistakeType = [resultSet intForColumn:@"mistakeType"];
            
            model.idNum = idNum;
            model.multi_radio = multi_radio;
            model.name_bin = name;
            model.option = option;
            model.answer = answer;
            model.test_answer_bin = test_answer_bin;
            model.err_rate = err_rate;
            model.type = type;
            model.class_type = class_type;
            model.media_type = media_type;
            model.is_img = is_img;
            model.addtime = addtime;
            model.is_del = is_del;
            model.chapter = chapter;
            model.image_bin = imgdata;
            model.mistakeType = mistakeType;
            
            [array addObject:model];
        }
    }];
    return array;
    


}



@end
