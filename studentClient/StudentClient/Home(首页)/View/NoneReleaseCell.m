//
//  NoneReleaseCell.m
//  学员端
//
//  Created by gaobin on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NoneReleaseCell.h"

@implementation NoneReleaseCell

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
        self.backgroundColor = BG_COLOR;
        _noneReleaseImgView = [[UIImageView alloc] init];
        [self addSubview:_noneReleaseImgView];
        
   
    }
    return self;
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_noneReleaseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
}
@end
