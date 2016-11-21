//
//  StudyCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyButton.h"

typedef enum{
    
    StudyCellButtonSubjectOne = 0,
    
    StudyCellButtonSubjectTwo,

    StudyCellButtonSubjectThree,
    
    StudyCellButtonSubjectFour,
    
    StudyCellButtonSubjectOrder,
    
    StudyCellButtonSubjectStudy,

}StudyCellButtonType;

@protocol StudyCellDelegate <NSObject>

-(void)studyCellDidClickBtnWithButtonType:(StudyCellButtonType)btnType;

@end



@interface StudyCell : UITableViewCell

- (IBAction)subject1Click:(id)sender;

- (IBAction)subject2Click:(id)sender;

- (IBAction)subject3Click:(id)sender;

- (IBAction)subject4Click:(id)sender;

- (IBAction)orderClick:(id)sender;

- (IBAction)studyClick:(id)sender;

@property (weak, nonatomic) IBOutlet StudyButton *subject1;

@property (weak, nonatomic) IBOutlet StudyButton *subject2;

@property (weak, nonatomic) IBOutlet StudyButton *subject3;

@property (weak, nonatomic) IBOutlet StudyButton *subject4;

@property (weak, nonatomic) IBOutlet StudyButton *orderBtn;

@property (weak, nonatomic) IBOutlet StudyButton *studyBtn;

@property (nonatomic, assign)CGFloat  cellHeight;

@property(nonatomic,weak)id<StudyCellDelegate> delegate;



@end
