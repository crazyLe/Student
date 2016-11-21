//
//  UnBindCoachCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    UnBindCoachSubject2 = 0,
    UnBindCoachSubject3,

}UnBindCoachSubjectType;

typedef void(^UnBindCoachCellClickBtnBlock) (UnBindCoachSubjectType);

@interface UnBindCoachCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *subjectTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *subjectThreeBtn;
- (IBAction)subject2Click:(id)sender;
- (IBAction)subject3Click:(id)sender;

@property(nonatomic,copy)UnBindCoachCellClickBtnBlock clickBtnBlock;


@end
