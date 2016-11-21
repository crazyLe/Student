//
//  PersonalCustomizeCell.h
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderModel.h"

@protocol PersonalCustomizeCellDelegate <NSObject>

- (void)clickPersonalCustomizeCellDeleteBtn:(NSInteger)index;

@end

@interface PersonalCustomizeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderInfoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *studySecretaryLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *isRepayImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *isStateLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) MyOrderModel * orderModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id<PersonalCustomizeCellDelegate>delegate;

@end
