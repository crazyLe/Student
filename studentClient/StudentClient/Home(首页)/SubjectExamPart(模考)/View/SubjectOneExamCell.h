//
//  SubjectOneExamCell.h
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectOneExamCell;

@protocol SubjectOneExamCellDelegate <NSObject>

-(void)subjectOneExamCellDidClickStartBtn:(SubjectOneExamCell *)cell;

@end

@interface SubjectOneExamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *examBankLab;
@property (weak, nonatomic) IBOutlet UILabel *examBankLab1;
@property (weak, nonatomic) IBOutlet UILabel *examTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *examTimeLab1;
@property (weak, nonatomic) IBOutlet UILabel *standardLab;
@property (weak, nonatomic) IBOutlet UILabel *standardLab1;
@property (weak, nonatomic) IBOutlet UILabel *questionRuleLab;
@property (weak, nonatomic) IBOutlet UILabel *questionRuleLab1;
@property (weak, nonatomic) IBOutlet UILabel *examRuleLab;
@property (weak, nonatomic) IBOutlet UILabel *examRuleLab1;
@property (weak, nonatomic) IBOutlet UIButton *startExamBtn;
@property (weak, nonatomic) IBOutlet UIView *lineViewOne;
@property (weak, nonatomic) IBOutlet UIView *lineViewTwo;
@property (weak, nonatomic) IBOutlet UIView *lineViewThree;
@property (weak, nonatomic) IBOutlet UIView *lineViewFour;
@property(nonatomic,weak)id<SubjectOneExamCellDelegate> delegate;

@property(nonatomic,strong)NSString * subjectNum;


@end
