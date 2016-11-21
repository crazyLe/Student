//
//  NewWalfCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudyButton.h"

typedef enum {

    NewWalfCellBtnWeiMingPian = 0,
    NewWalfCellBtnZhuanXueFei,
    NewWalfCellBtnDaiJingQuan,
    NewWalfCellBtnDebitredit

}NewWalfCellBtnType;

@class NewWalfCell;

@protocol NewWalfCellDelegate <NSObject>

-(void)newWalfCell:(NewWalfCell *)cell didClickBtnWithBtnType:(NewWalfCellBtnType)type;

@end

@interface NewWalfCell : UITableViewCell

- (IBAction)weiMingPianClick:(id)sender;

- (IBAction)zhuanXueFeiClick:(id)sender;

- (IBAction)daiJingQuanClick:(id)sender;

- (IBAction)debitCreditClick:(id)sender;


@property (weak, nonatomic) IBOutlet StudyButton *weiMingPian;

@property (weak, nonatomic) IBOutlet StudyButton *zhuanXueFei;

@property (weak, nonatomic) IBOutlet StudyButton *daiJingQuan;

@property (weak, nonatomic) IBOutlet StudyButton *debitAndCreditBtn;


@property (nonatomic, assign)CGFloat  cellHeight;

@property(nonatomic,weak)id<NewWalfCellDelegate> delegate;



@end
