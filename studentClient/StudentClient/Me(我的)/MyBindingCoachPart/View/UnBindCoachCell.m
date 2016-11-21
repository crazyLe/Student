//
//  UnBindCoachCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "UnBindCoachCell.h"

@implementation UnBindCoachCell
{
    UIButton *_currentBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subjectTwoBtn.layer.cornerRadius = 20.0f;
    self.subjectTwoBtn.clipsToBounds = YES;
    self.subjectThreeBtn.layer.cornerRadius = 20.0f;
    self.subjectThreeBtn.clipsToBounds = YES;
    
    [self.subjectTwoBtn setborderWidth:1.0 borderColor:[UIColor colorWithHexString:@"5cb6ff"]];
    
    [self.subjectThreeBtn setborderWidth:1.0 borderColor:[UIColor colorWithHexString:@"5cb6ff"]];
    
    self.subjectThreeBtn.backgroundColor = [UIColor whiteColor];
    [self.subjectThreeBtn setTitleColor:[UIColor colorWithHexString:@"5cb6ff"] forState:UIControlStateNormal];

    _currentBtn = self.subjectTwoBtn;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subject2Click:(UIButton *)sender {
    
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [_currentBtn setTitleColor:[UIColor colorWithHexString:@"5cb6ff"] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _currentBtn = sender;
    
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UnBindCoachSubject2);
    }
    
}

- (IBAction)subject3Click:(UIButton *)sender {
    
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [_currentBtn setTitleColor:[UIColor colorWithHexString:@"5cb6ff"] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _currentBtn = sender;
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UnBindCoachSubject3);
    }
}
@end
