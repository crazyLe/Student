//
//  LLWithdrawAmountCell.h
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBtnBlock) (NSString *money);

@interface LLWithdrawAmountCell : SuperTableViewCell

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) NSMutableArray *btnArr;

@property(nonatomic,strong)UIButton * currentBtn;

@property(nonatomic,copy)SelectedBtnBlock selectedBtnBlock;



@end
