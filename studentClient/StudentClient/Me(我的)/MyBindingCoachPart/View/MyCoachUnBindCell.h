//
//  MyCoachUnBindCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCoachUnBindCell,CoachModel;

typedef void(^gotoBDingController)();

@protocol MyCoachUnBindCellDelegate <NSObject>

@end
@interface MyCoachUnBindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *lijiBindBtn;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property(strong,nonatomic)gotoBDingController gotoBlock;
@property(weak,nonatomic)id <MyCoachUnBindCellDelegate> delegate;

- (IBAction)lijiBindBtnClick:(id)sender;

@end
