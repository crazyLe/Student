//
//  MyTrainerCell.m
//  学员端
//
//  Created by gaobin on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyTrainerCell.h"

@implementation MyTrainerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
        
        _myTrainerLab = [[UILabel alloc] init];
        _myTrainerLab.frame = CGRectMake(12, 19, 200, 18);
        _myTrainerLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _myTrainerLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _myTrainerLab.text = @"我绑定教练的陪练";
        [self addSubview:_myTrainerLab];
        
    }
    return self;
}
@end
