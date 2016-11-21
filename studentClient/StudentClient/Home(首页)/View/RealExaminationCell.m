//
//  RealExaminationCell.m
//  学员端
//
//  Created by gaobin on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RealExaminationCell.h"

@implementation RealExaminationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _realExaminationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_realExaminationBtn];
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _realExaminationBtn.frame = CGRectMake(13, 5, kScreenWidth - 26, (kScreenWidth - 26)*0.3337);

}

@end
