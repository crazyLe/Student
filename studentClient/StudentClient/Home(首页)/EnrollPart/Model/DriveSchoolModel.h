//
//  DriveSchoolModel.h
//  学员端
//
//  Created by gaobin on 16/8/2.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriveSchoolModel : NSObject

@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int idNum;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, assign) Boolean installment;
@property (nonatomic, assign) int orderType;
@property (nonatomic, assign) Boolean preferential;
@property (nonatomic, assign) int reports;
@property (nonatomic, copy) NSString * schoolName;
@property (nonatomic, copy) NSString * weburl;




@end
