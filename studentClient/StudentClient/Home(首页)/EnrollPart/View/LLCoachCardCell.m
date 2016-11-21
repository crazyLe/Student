//
//  LLCoachCardCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"
#import "LLCoachCardCell.h"
#import "FindCoachModel.h"
@implementation LLCoachCardCell

- (void)setUI
{
    _bgView = [UIView new];
    _bgView.userInteractionEnabled = YES;
    [self.contentView  addSubview:_bgView];
    
//    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn = [[UIImageView alloc]init];
    [_bgView addSubview:_headBtn];
    
    _couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_couponBtn];
    
    _stageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_stageBtn];
    
    _seniorCoachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_seniorCoachBtn];
    
    _noSmokingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_noSmokingBtn];
    
    _nightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_nightBtn];
    
    _distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_distanceBtn];
    
    _priceLbl = [UILabel new];
    [_bgView addSubview:_priceLbl];
    
    _nameLbl = [UILabel new];
    [_bgView addSubview:_nameLbl];
    
    _classInfoLbl = [UILabel new];
    [_bgView addSubview:_classInfoLbl];
    
    _locationLbl = [UILabel new];
    [_bgView addSubview:_locationLbl];
    
    _locationImgView = [UIImageView new];
    [_bgView addSubview:_locationImgView];
}

- (void)setContraints
{
    WeakObj(_headBtn)
    WeakObj(_bgView)
    WeakObj(_nameLbl)
    WeakObj(_couponBtn)
    WeakObj(_stageBtn)
    WeakObj(_classInfoLbl)
    WeakObj(_seniorCoachBtn)
    WeakObj(_noSmokingBtn)
    WeakObj(_locationImgView)
    WeakObj(_priceLbl)

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(20);
        make.width.height.equalTo(_bgViewWeak.mas_height).multipliedBy(0.45);
       
        
    }];
    
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headBtnWeak.mas_bottom);
//        make.left.right.equalTo(_headBtnWeak).multipliedBy(1.6);
        make.left.equalTo(_headBtnWeak).offset(-10);
        make.right.equalTo(_headBtnWeak).offset(20);
        make.bottom.offset(-5);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLblWeak.mas_right);
        make.top.equalTo(_headBtnWeak);
        make.height.offset(25);
        make.right.offset(0);
    }];
    
    [_distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameLblWeak.mas_top).offset(5);
        make.right.offset(0);
        make.width.offset(80);
        make.top.offset(5);
    }];
    
    [_couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak);
        make.top.equalTo(_nameLblWeak.mas_bottom).offset(5);
        make.width.height.offset(20);
    }];
    
    [_stageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_couponBtnWeak.mas_right).offset(5);
        make.top.height.equalTo(_couponBtnWeak);
        make.width.equalTo(_stageBtnWeak.mas_height).multipliedBy(3);
    }];
    
    [_classInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_nameLblWeak);
        make.top.equalTo(_stageBtnWeak.mas_bottom).offset(2);
        make.height.offset(25);
    }];
    
    [_seniorCoachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak);
        make.top.equalTo(_classInfoLblWeak.mas_bottom);
        make.width.height.equalTo(_stageBtnWeak);
    }];
    
    [_noSmokingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_seniorCoachBtnWeak.mas_right).offset(5);
        make.top.height.equalTo(_seniorCoachBtnWeak);
        make.width.offset(50);
    }];
    
    [_nightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_noSmokingBtnWeak.mas_right).offset(5);
        make.height.width.top.equalTo(_seniorCoachBtnWeak);
    }];
    
    [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLblWeak);
        make.top.equalTo(_seniorCoachBtnWeak.mas_bottom).offset(5);
        make.width.height.offset(20);
    }];
    
    [_locationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationImgViewWeak.mas_right);
        make.top.height.equalTo(_locationImgViewWeak);
        make.right.offset(-10);
    }];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius =((self.frame.size.height-10)*0.45)/2;

}
- (void)setAttributes
{
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgView.layer.shadowOpacity = 0.05f;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);

    _priceLbl.numberOfLines = 0;
    _priceLbl.textAlignment = NSTextAlignmentCenter;
    
    _couponBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _couponBtn.userInteractionEnabled = NO;
    [_couponBtn setTitleColor:[UIColor colorWithHexString:@"74d022"] forState:UIControlStateNormal];
    
    _stageBtn.titleLabel.font = _couponBtn.titleLabel.font;
    _stageBtn.userInteractionEnabled = NO;
    [_stageBtn setTitleColor:[UIColor colorWithHexString:@"5cb6ff"] forState:UIControlStateNormal];
    
    _classInfoLbl.textColor = [UIColor colorWithHexString:@"999999"];
    _classInfoLbl.font = [UIFont systemFontOfSize:13];
    
    _seniorCoachBtn.titleLabel.textColor = [UIColor whiteColor];
    _seniorCoachBtn.userInteractionEnabled = NO;
    _seniorCoachBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _noSmokingBtn.titleLabel.textColor = [UIColor whiteColor];
    _noSmokingBtn.userInteractionEnabled = NO;
     _noSmokingBtn.titleLabel.font = _seniorCoachBtn.titleLabel.font;
    
    _nightBtn.titleLabel.textColor = [UIColor whiteColor];
    _nightBtn.userInteractionEnabled = NO;
    _nightBtn.titleLabel.font = _seniorCoachBtn.titleLabel.font;
    
    _locationLbl.textColor = [UIColor colorWithHexString:@"999999"];
    _locationLbl.font = [UIFont systemFontOfSize:13];
    
    [_distanceBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
    _distanceBtn.userInteractionEnabled = NO;
    _distanceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (void)setPriceLbl:(NSString *)price marketPrice:(NSString *)marketPrice
{
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:price attributes:@[[UIColor colorWithHexString:@"5db7fe"],[UIFont boldSystemFontOfSize:20]]];
    [attStr appendBreakLineWithInterval:5];
//    [attStr appendText:@"市场价:" withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],@(12)]];
//    [attStr appendText:marketPrice withAttributesArr:@[[UIColor colorWithHexString:@"c8c8c8"],@(12),@(NSMutableAttributedStringExtensionTypeLineThrough)]];
    [_priceLbl setAttributedText:attStr];
}
- (void)setNameLbl:(NSString *)name img:(UIImage *)img bounds:(CGRect)bounds driving:(NSString *)driving
{
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:name attributes:@[[UIColor colorWithHexString:@"656565"],[UIFont boldSystemFontOfSize:20]]];
    [attStr appendImg:img bounds:bounds];
    [attStr appendText:driving withAttributesArr:@[[UIColor colorWithHexString:@"999999"],@(13)]];
    [_nameLbl setAttributedText:attStr];
}

- (void)setModel:(FindCoachModel *)model
{
    _model = model;
    
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fcfcfc"]]];
    
    [_headBtn setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholder:[UIImage imageNamed:@"coachAvatar"]];

    [self setPriceLbl:[NSString stringWithFormat:@"¥%@",model.TuitionFees] marketPrice:@"2000"];
    
    [self setNameLbl:model.coachsName img:[UIImage imageNamed:@"认证"]  bounds:CGRectMake(5, -5, 20, 20) driving:[NSString stringWithFormat:@"    %@",model.shoolname]];
    
//    [_distanceBtn setImage:[UIImage imageNamed:@"iconfont-juli"] forState:UIControlStateNormal];
//     [_distanceBtn setTitle:[self distance:model.distance] forState:UIControlStateNormal];
    
    if (model.preferential) {
        [_couponBtn setTitle:@"惠" forState:UIControlStateNormal];
        [_couponBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-green"] forState:UIControlStateNormal];
    }
    
    if (model.installment) {
        
        if (!model.preferential) {
            [_stageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLbl);
            }];
        }
        [_stageBtn setTitle:@"支持分期" forState:UIControlStateNormal];
        [_stageBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-blue"] forState:UIControlStateNormal];
    }
    
    _classInfoLbl.text = model.classname;
    
    for (int i = 0; i<model.tag.count; i++) {
        
        if (0 == i) {
            [_seniorCoachBtn setTitle:model.tag[i] forState:UIControlStateNormal];
            [_seniorCoachBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
        }else if (1 == i)
        {
            [_noSmokingBtn setTitle:model.tag[i] forState:UIControlStateNormal];
            [_noSmokingBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
           
        }else if (2 == i)
        {
            [_nightBtn setTitle:model.tag[i] forState:UIControlStateNormal];
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
        }
    }
    
    _locationImgView.image = [UIImage imageNamed:@"iconfont-dizhi"];
    
    _locationLbl.text = model.address;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:246/255.0 blue:245/255.0 alpha:1];

//    [cell setPriceLbl:@"¥4000" marketPrice:@"¥4800"];
//    [cell setNameLbl:@"张伟" img:[UIImage imageNamed:@"认证"] bounds:CGRectMake(5, -5, 20, 20) driving:@"  合肥八一驾校"];
//    [cell.couponBtn setTitle:@"惠" forState:UIControlStateNormal];
//    [cell.couponBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-green"] forState:UIControlStateNormal];
//    [cell.stageBtn setTitle:@"支持分期" forState:UIControlStateNormal];
//    [cell.stageBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-blue"] forState:UIControlStateNormal];
//    cell.classInfoLbl.text = @"C1、普通班、商务班、VIP班、钻石班...";
//    [cell.seniorCoachBtn setTitle:@"资深教练" forState:UIControlStateNormal];
//    [cell.seniorCoachBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
//    [cell.noSmokingBtn setTitle:@"不吸烟" forState:UIControlStateNormal];
//    [cell.noSmokingBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
//    [cell.nightBtn setTitle:@"夜间培训" forState:UIControlStateNormal];
//    [cell.nightBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-gray"] forState:UIControlStateNormal];
//    cell.locationImgView.image = [UIImage imageNamed:@"iconfont-dizhi"];
//    cell.locationLbl.text = @"合肥临泉路与新蚌路交口长安驾校训练场";
//    cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:246/255.0 blue:245/255.0 alpha:1];
//    [cell.distanceBtn setImage:[UIImage imageNamed:@"iconfont-juli"] forState:UIControlStateNormal];
//    [cell.distanceBtn setTitle:@"0.9km" forState:UIControlStateNormal];
    
}
- (NSString *)distance:(NSString *)str
{
    double dis = [str doubleValue]/1000;
    
    return [NSString stringWithFormat:@"%.2fkm",dis];
}

@end
