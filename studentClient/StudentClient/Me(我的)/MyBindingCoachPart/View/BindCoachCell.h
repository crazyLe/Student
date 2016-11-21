//
//  BindCoachCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BindCoachCell,CoachModel;

@protocol BindCoachCellDelegate <NSObject>

@optional
-(void)bindCoachCellDidClickBindBtn:(BindCoachCell *)cell;

@end

@interface BindCoachCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;
- (IBAction)bindingBtnClick:(id)sender;
@property(nonatomic,weak)id<BindCoachCellDelegate> delegate;

@property(strong,nonatomic)CoachModel *coach;

@end
