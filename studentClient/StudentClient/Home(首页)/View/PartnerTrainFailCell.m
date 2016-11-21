//
//  PartnerTrainFailCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainFailCell.h"

@implementation PartnerTrainFailCell
{
    UIImageView *bigImageView;
    NSMutableArray *_imageViewsArray;
    UIButton *_bigBtn;
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UILabel *_zhuanDouLabel;
    UILabel *_timeLabel;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = BG_COLOR;
        UIImageView *imageView = [[UIImageView alloc]init];
        bigImageView = imageView;
        imageView.clipsToBounds = NO;
        imageView.image = [UIImage imageNamed:@"椭圆-1"];
        [self.contentView addSubview:imageView];
        
        _imageViewsArray = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
            [self.contentView addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
        
        UIButton *bigButton = [[UIButton alloc]init];
        _bigBtn = bigButton;
        _bigBtn.userInteractionEnabled = NO;
        [bigButton setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1-拷贝-3"] forState:UIControlStateNormal];
        [self.contentView addSubview:bigButton];
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        _iconImageView = iconImageView;
        iconImageView.image = [UIImage imageNamed:@"订单结果3"];
        [self.contentView addSubview:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        _titleLabel = titleLabel;
        _titleLabel.font = [UIFont systemFontOfSize:15*AutoSizeScaleX];
        titleLabel.textColor = [UIColor colorWithHexString:@"fd5e5d"];
        [self.contentView addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        _timeLabel = timeLabel;
        _timeLabel.text = @"今天5:30";
        timeLabel.font = [UIFont systemFontOfSize:11*AutoSizeScaleX];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:timeLabel];
        
        UILabel *subTiltleLabel = [[UILabel alloc]init];
        _subTitleLabel = subTiltleLabel;
        subTiltleLabel.text = @"原因:教练确认超时";
        subTiltleLabel.font = [UIFont systemFontOfSize:12*AutoSizeScaleX];
        subTiltleLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:subTiltleLabel];
        
        UILabel *zhuanDouLabel = [[UILabel alloc]init];
        _zhuanDouLabel = zhuanDouLabel;
        zhuanDouLabel.text = @"赚豆已退还账户";
        zhuanDouLabel.font = [UIFont systemFontOfSize:12*AutoSizeScaleX];
        zhuanDouLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:zhuanDouLabel];
        
        
        
    }
    return self;
    
}
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    _titleLabel.text = titleString;
}
-(void)setSubTitleString:(NSString *)subTitleString
{
    _subTitleString = subTitleString;
    _subTitleLabel.text = subTitleString;

}
-(void)setZhuanDouString:(NSString *)zhuanDouString
{
    _zhuanDouString = zhuanDouString;
    
    _zhuanDouLabel.text = zhuanDouString;

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    bigImageView.frame = CGRectMake(4, 10,35, 35);
    
    for (int i = 0; i<5; i++) {
        UIImageView *imageView = _imageViewsArray[i];
        imageView.frame = CGRectMake(20, 40+(3+8)*i, 3, 3);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.width/2;
    }
    _bigBtn.frame = CGRectMake(40, 10, kScreenWidth-40-10,80);
    _iconImageView.frame = CGRectMake(59, 20, 49, 49);
    _titleLabel.frame = CGRectMake(67+49, 15, 180, 22);
    _timeLabel.frame = CGRectMake(kScreenWidth-60-10-10, 15, 60, 21);
    _subTitleLabel.frame = CGRectMake(67+49, 37, 120, 18);
    _zhuanDouLabel.frame = CGRectMake(67+49, 52, 120, 21);

    
}
-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    
    _timeLabel.text = timeString;

}
/**
 *  if you're using frame layout mode, you must override -sizeThatFits: in your customized cell
 */
-(CGSize)sizeThatFits:(CGSize)size
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    UIImageView *lastV = [_imageViewsArray lastObject];
    CGFloat height = CGRectGetMaxY(lastV.frame)+10;
    return CGSizeMake(size.width,height);
}

@end
