//
//  HeaderReusableView.m
//  学员端
//
//  Created by gaobin on 16/7/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView
{

    ZHPickView *_fromPickerView;
    
    ZHPickView *_toPickerView;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 30, 12)];
        timeLab.text = @"时段:";
        timeLab.font = [UIFont systemFontOfSize:13];
        timeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
        [self addSubview:timeLab];
        
        UILabel * carTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 62, 30, 12)];
        carTypeLab.text = @"车型:";
        carTypeLab.font = [UIFont systemFontOfSize:13];
        carTypeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
        [self addSubview:carTypeLab];
        
        _fromTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromTimeBtn.backgroundColor = [UIColor whiteColor];
        [_fromTimeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        [_fromTimeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _fromTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_fromTimeBtn addTarget:self action:@selector(fromTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_fromTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_fromTimeBtn.layer setBorderWidth:.5];
        [self addSubview:_fromTimeBtn];
        [_fromTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLab);
            make.left.equalTo(timeLab.mas_right).offset(5);
            make.width.offset(60);
            make.height.offset(27);
        }];
        
        UILabel * zhiLab = [[UILabel alloc] init];
        zhiLab.text = @"至";
        zhiLab.textColor = [UIColor colorWithHexString:@"#999999"];
        zhiLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:zhiLab];
        [zhiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fromTimeBtn.mas_right).offset(5);
            make.centerY.equalTo(_fromTimeBtn);
        }];
        
        _toTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toTimeBtn.backgroundColor = [UIColor whiteColor];
        [_toTimeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _toTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_toTimeBtn setTitle:@"24:00" forState:UIControlStateNormal];
        [_toTimeBtn addTarget:self action:@selector(toTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_toTimeBtn.layer setBorderWidth:.5];
        [self addSubview:_toTimeBtn];
        [_toTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(zhiLab.mas_right).offset(5);
            make.centerY.equalTo(zhiLab);
            make.width.offset(60);
            make.height.offset(27);
        }];
        
        
        UIButton * carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        carTypeBtn.backgroundColor = [UIColor whiteColor];
        [carTypeBtn setTitle:@"全部" forState:UIControlStateNormal];
        [carTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];

        carTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];

        self.carTypeBtn = carTypeBtn;
        [carTypeBtn addTarget:self action:@selector(carTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        carTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];

        carTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        carTypeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        [carTypeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [carTypeBtn.layer setBorderWidth:.5];
        [self addSubview:carTypeBtn];
        [carTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fromTimeBtn.mas_left);
            make.centerY.equalTo(carTypeLab);
            make.width.offset(100);
            make.height.offset(27);
        }];
        UIImageView * triangleImgView = [[UIImageView alloc] init];
        triangleImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
        [carTypeBtn addSubview:triangleImgView];
        [triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(carTypeBtn);
        }];
        

        
        
        
    }
    return self;
}
-(void)fromTimeBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        [self.delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeFrom];
    }
    
   
    


}
-(void)toTimeBtnClick
{

    if ([self.delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        [self.delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeTo];
    }


}
-(void)carTypeBtnClick
{

    if ([self.delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        [self.delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeCarType];
    }


}
@end
