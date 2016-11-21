//
//  LLLicenceTypeCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLLicenceTypeCell : SuperTableViewCell   

@property (nonatomic,strong)UILabel *titleLbl;

@property (nonatomic,strong) NSMutableArray *btnArr;

@property (nonatomic,strong) NSMutableDictionary *filterSelectDic;

@end
