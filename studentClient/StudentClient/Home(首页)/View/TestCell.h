//
//  TestCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    SubjectBtn1 = 0,

    SubjectBtn4,
    
    KanTestBtn
    
}SubjectButtonType;

@class TestCell;
@protocol TestCellDelegate <NSObject>

-(void)testCell:(TestCell *)cell didClickSubjectButtonWithType:(SubjectButtonType)btnType;

@end

@interface TestCell : UITableViewCell

@property(nonatomic,weak)id<TestCellDelegate> delegate;

@property (nonatomic, assign)CGFloat  cellHeight;

@property (weak, nonatomic) IBOutlet UIButton *subjectBtn1;

@property (weak, nonatomic) IBOutlet UIButton *kanTestBtn;

@property (weak, nonatomic) IBOutlet UIButton *subjectBtn4;
- (IBAction)subject1Click:(id)sender;

- (IBAction)subject4Click:(id)sender;

- (IBAction)kanTestBtnClick:(id)sender;


@end
