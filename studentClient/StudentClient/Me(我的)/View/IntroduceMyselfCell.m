//
//  IntroduceMyselfCell.m
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "IntroduceMyselfCell.h"

@implementation IntroduceMyselfCell
{
    UILabel * _placeLab;
 
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置占位label
    _placeLab = [[UILabel alloc] init];
    _placeLab.font = [UIFont systemFontOfSize:15];
    //  _placeLab.text = @"自我介绍";
    _placeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _placeLab.enabled = NO;

    [_textView addSubview:_placeLab];

}


- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeLab.text = @"自我介绍";

    }else {
        _placeLab.text = @"";

    }
    
    if (_textView.text.length>120) {
        _textView.text = [_textView.text substringToIndex:120];
    }
    
    _limitInputLab.text = [NSString stringWithFormat:@"%lu/120",(unsigned long)_textView.text.length];

    self.personalInfo.introduce = textView.text;
    
}
- (void)setPersonalInfo:(PersonalInfoModel *)personalInfo {
    
    _personalInfo = personalInfo;
    
    _textView.delegate = self;
    [_textView setValue:@119 forKey:@"LimitInput"];
    
    
    [_placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
    }];
    
    
     _limitInputLab.textColor = [UIColor colorWithHexString:@"#999999"];
    
    
    if ([personalInfo.introduce isEqualToString:@""]) {

        _placeLab.text = @"自我介绍";
        
        _limitInputLab.text = @"4/120";
        
    }else {
        
        _textView.text = _personalInfo.introduce;

        _limitInputLab.text = [NSString stringWithFormat:@"%lu/120",(unsigned long)_textView.text.length];
        
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
