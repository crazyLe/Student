//
//  VideoCell.m
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

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
        self.backgroundColor = [UIColor whiteColor];
        
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 20, (kScreenWidth-33)/2, 104)];
        _leftImgView.image = [UIImage imageNamed:@"图层-7"];
        [self addSubview:_leftImgView];
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-33)/2 + 22, 20, (kScreenWidth-33)/2, 104)];
        _rightImgView.image = [UIImage imageNamed:@"图层-7"];
        [self addSubview:_rightImgView];
        
        _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 135, 100, 20)];
        _leftLab.text = @"课一理论讲师教学";
        _leftLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _leftLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_leftLab];
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-33)/2 + 22, 135, 100, 20)];
        _rightLab.text = @"情景模拟试题还原";
        _rightLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _rightLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_rightLab];
        
        _leftCameraView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 50, 135, 20, 20)];
        _leftCameraView.image = [UIImage imageNamed:@"iconfont-01fuben-副本-2"];
        [self addSubview:_leftCameraView];
        _rightCamerwView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50 -6, 135, 20, 20)];
        _rightCamerwView.image = [UIImage imageNamed:@"iconfont-01fuben-副本-2"];
        [self addSubview:_rightCamerwView];
        
        _leftTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 70, 135, 70 - 6, 20)];
        _leftTimeLab.text = @"3:21";
        _leftTimeLab.font = [UIFont systemFontOfSize:9];
        _leftTimeLab.textAlignment = NSTextAlignmentRight;
        _leftTimeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        [self addSubview:_leftTimeLab];
        _rightTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70 -6, 135, 70 - 6, 20)];
        _rightTimeLab.text = @"3:21";
        _rightTimeLab.font = [UIFont systemFontOfSize:9];
        _rightTimeLab.textAlignment = NSTextAlignmentRight;
        _rightTimeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        [self addSubview:_rightTimeLab];
        
    }
    
    return self;
    
    
}
@end
