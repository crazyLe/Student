//
//  ExtraMoneyVC.h
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    ExtraMoneyVCTypeAdmissionEarn = 1,
    ExtraMoneyVCTypeExtraMoney
}ExtraMoneyVCType;

@interface ExtraMoneyVC : BaseViewController

@property (nonatomic,assign) ExtraMoneyVCType type;

@end



@interface BeansRecord : NSObject

@property(nonatomic,strong)NSString * beans;

@property(nonatomic,strong)NSString * className;

@property(nonatomic,assign)long time;

@property(nonatomic,strong)NSString * timeStr;

@property(nonatomic,strong)NSString * month;

@end

@interface BeansRecordGroup : NSObject

@property(nonatomic,strong)NSString * month;

@property(nonatomic,strong)NSMutableArray * records;



@end

