//
//  LLStudentTaskCell.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLProgressView.h"
#import "LLWalletSuperCell.h"
#import <UIKit/UIKit.h>


@interface LLStudentTaskCell : LLWalletSuperCell

@property (nonatomic,strong) UILabel  *taskProgressLbl,*alreadyReceiveLbl,*canReceiveLbl;

@property (nonatomic,strong) LLProgressView *progressView;

@end
