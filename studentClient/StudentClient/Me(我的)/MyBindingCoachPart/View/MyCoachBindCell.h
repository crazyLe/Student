//
//  MyCoachBindCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCoachBindCell,CoachModel;
@protocol MyCoachBindCellDelegate <NSObject>

@optional
- (void)jiechuBDingCoach:(MyCoachBindCell *)cell;

@end
@interface MyCoachBindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBindBtn;
- (IBAction)cancelBindBtnClick:(id)sender;

@property(weak,nonatomic)id <MyCoachBindCellDelegate> delegate;
@property(strong,nonatomic)CoachModel *coach;
@end
