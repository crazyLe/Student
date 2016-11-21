//
//  ExamQuestionModel.m
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamQuestionModel.h"

@implementation ExamQuestionModel


-(void)setName_bin:(NSString *)name_bin
{
    
    NSString* headerData=nil;
    
    headerData = [name_bin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
   //TODU
    _name_bin = headerData;


}
-(void)setOption:(NSString *)option
{
    NSString* headerData=nil;
    
    headerData = [option stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    
    _option = headerData;

}
@end
