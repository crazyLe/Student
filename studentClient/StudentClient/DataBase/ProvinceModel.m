//
//  ProvinceModel.m
//  学员端
//
//  Created by zuweizhong  on 16/8/9.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"idNum":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"citys":[CityModel class]};


}


//将对象编码(即:序列化)
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(_idNum) forKey:@"idNum"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:@(_parent_id) forKey:@"parent_id"];
    [aCoder encodeObject:_citys forKey:@"citys"];
}

//将对象解码(反序列化)
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.idNum =[[aDecoder decodeObjectForKey:@"idNum"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.parent_id =[[aDecoder decodeObjectForKey:@"parent_id"] intValue];
        self.citys =[aDecoder decodeObjectForKey:@"citys"];
    }
    return self;
    
}





@end

@implementation CityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"idNum":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"countrys":[CountryModel class]};
    
    
}

//将对象编码(即:序列化)
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(_idNum) forKey:@"idNum"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:@(_parent_id) forKey:@"parent_id"];
    [aCoder encodeObject:_countrys forKey:@"countrys"];
}

//将对象解码(反序列化)
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.idNum =[[aDecoder decodeObjectForKey:@"idNum"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.parent_id =[[aDecoder decodeObjectForKey:@"parent_id"] intValue];
        self.countrys =[aDecoder decodeObjectForKey:@"countrys"];
    }
    return self;
    
}


@end

@implementation CountryModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"idNum":@"id"};
}

//将对象编码(即:序列化)
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(_idNum) forKey:@"idNum"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:@(_parent_id) forKey:@"parent_id"];
}

//将对象解码(反序列化)
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.idNum =[[aDecoder decodeObjectForKey:@"idNum"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.parent_id =[[aDecoder decodeObjectForKey:@"parent_id"] intValue];
    }
    return self;
    
}



@end