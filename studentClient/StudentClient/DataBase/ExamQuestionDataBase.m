//
//  ExamQuestionDataBase.m
//  学员端
//
//  Created by zuweizhong  on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamQuestionDataBase.h"
#import <FMDatabase.h>
#import "FMDatabaseQueue.h"

#define FORCE_RECOPY_DB NO

@implementation ExamQuestionDataBase
{
    FMDatabaseQueue *queue;
}
#pragma mark - 实现类方法,单例方法
+ (instancetype)shareInstance
{
    static ExamQuestionDataBase *db = nil;
    @synchronized(self)
    {
        if (db == nil)
        {
            db = [[ExamQuestionDataBase alloc] init];
        }
    }
    return db;
}
-(instancetype)init
{
    if (self = [super init]) {
        
        //必须要copy，不然在工程目录中的数据库不能写入
        [self copyDatabaseIfNeeded];
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"exam.db"];
        
        HJLog(@"%@",destinationPath);
        
        queue = [FMDatabaseQueue databaseQueueWithPath:destinationPath];
        
    }
    return self;
    
}

-(void)deleteAllDataWithDB:(FMDatabase *)db
{
    
    NSString * sql = [NSString stringWithFormat:@"DELETE from exam"];

    __block BOOL result;
    
    result = [db executeUpdate:sql];
    if (!result) {
        HJLog(@"删除数据失败------%@",db.lastErrorMessage);
    }
    else
    {
        HJLog(@"删除数据成功------");
        
    }
        

}
-(NSArray *)query
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];

    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  @"select * from exam";
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            

            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];

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
            
            [array addObject:model];
        }
    }];
    return array;

}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
-(NSArray *)queryExamOneQuestionWithClassType:(NSString *)type
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM exam WHERE type=%@ and class_type like '%%%@%%'",@"1",type];
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;



}
-(NSArray *)queryExamFourQuestionWithClassType:(NSString *)type
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM exam WHERE type=%@ and class_type like '%%%@%%'",@"4",type];
        FMResultSet *resultSet =  [db executeQuery:sql];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;
 
}
-(ExamQuestionModel *)queryExamQuestionModelWithID:(int)idNum
{
   
    ExamQuestionModel *model = [[ExamQuestionModel alloc] init];

    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql =  @"SELECT * FROM exam WHERE id = ?";
        
        FMResultSet *resultSet =  [db executeQuery:sql,@(idNum)];
        // 遍历结果集合

        while ([resultSet next])
        {
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            
        }
    }];
    
    return model;


}
-(NSArray *)queryExamOneQuestion
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {

        NSString *sql =  @"SELECT * FROM exam WHERE type = ?";

        FMResultSet *resultSet =  [db executeQuery:sql,@"1"];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;
    

}
-(NSArray *)queryExamFourQuestion
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql =  @"SELECT * FROM exam WHERE type = ?";
        FMResultSet *resultSet =  [db executeQuery:sql,@"4"];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;
    
    
}
-(NSArray *)query100ExamOneQuestions
{
    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql =  @"SELECT * FROM exam WHERE type = ? order by random() limit 100";

        FMResultSet *resultSet =  [db executeQuery:sql,@"1"];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;

}
-(NSArray *)query50ExamFourQuestions
{

    // 数据源
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [queue inDatabase:^(FMDatabase *db) {

        NSString *sql =  @"SELECT * FROM exam WHERE type = ? order by random() limit 50";

        FMResultSet *resultSet =  [db executeQuery:sql,@"4"];
        // 遍历结果集合
        while ([resultSet next])
        {
            ExamQuestionModel *model = [[ExamQuestionModel alloc] init];
            // 根据字段名字,获取字段的值
            int idNum = [resultSet intForColumn:@"id"];
            int multi_radio = [resultSet intForColumn:@"multi_radio"];
            
            NSData *data = [resultSet dataForColumn:@"name_bin"];
            NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *name = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
            NSString *option = [resultSet stringForColumn:@"option"];
            NSString *answer = [resultSet stringForColumn:@"answer"];
            NSData *imgdata = [resultSet dataForColumn:@"image_bin"];
            
            NSData *test_answer_binData = [resultSet dataForColumn:@"test_answer_bin"];
            NSString *base64String1 = [[NSString alloc]initWithData:test_answer_binData encoding:NSUTF8StringEncoding];
            NSData *decodedData1 = [[NSData alloc] initWithBase64EncodedString:base64String1 options:0];
            NSString *test_answer_bin = [[NSString alloc] initWithData:decodedData1 encoding:NSUTF8StringEncoding];
            
            
            float err_rate = [resultSet doubleForColumn:@"err_rate"];
            int media_type = [resultSet intForColumn:@"media_type"];
            int is_img = [resultSet intForColumn:@"is_img"];
            int type = [resultSet intForColumn:@"type"];
            NSString *class_type = [resultSet stringForColumn:@"class_type"];
            int addtime = [resultSet intForColumn:@"addtime"];
            int is_del = [resultSet intForColumn:@"is_del"];
            int chapter = [resultSet intForColumn:@"chapter"];
            
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
            
            [array addObject:model];
        }
    }];
    return array;

}
-(void)updateErrorRateWithRate:(NSString *)errorRate questionId:(int)idNum
{
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"UPDATE exam SET err_rate =? WHERE id = ?";
        NSInteger errRate = errorRate.integerValue;
        BOOL result = [db executeUpdate:sql,@(errRate),@(idNum)];
        if (!result)
        {
            HJLog(@"UPDATE 失败------%@",db.lastErrorMessage);
        }
        else
        {
            HJLog(@"UPDATE  successed!");
        }

    }];
    
}

- (void)copyDatabaseIfNeeded
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"exam.db"];
    
    void (^copyDb)(void) = ^(void){
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"exam" ofType:@"db"];
        NSAssert1(sourcePath, @"source db does not exist at path %@",sourcePath);
        
        NSError *copyError = nil;
        if( ![fm copyItemAtPath:sourcePath toPath:destinationPath error:&copyError] ) {
            HJLog(@"ERROR | db could not be copied: %@", copyError);
        }
    };
    if( FORCE_RECOPY_DB && [fm fileExistsAtPath:destinationPath] ) {
        [fm removeItemAtPath:destinationPath error:NULL];
        copyDb();
    }
    else if( ![fm fileExistsAtPath:destinationPath] ) {
        HJLog(@"INFO | db file needs copying");
        copyDb();
    }
}


@end
