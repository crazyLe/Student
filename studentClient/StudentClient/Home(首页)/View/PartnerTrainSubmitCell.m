//
//  PartnerTrainSubmitCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainSubmitCell.h"

@implementation PartnerTrainSubmitCell
{
    UIImageView *bigImageView;
    NSMutableArray *_imageViewsArray;
    UIButton *bigBtn;
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
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
            imageView.backgroundColor = [UIColor colorWithHexString:@"5eb5fd"];
            [self.contentView addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
        
        UIButton *bigButton = [[UIButton alloc]init];
        bigBtn = bigButton;
        [bigButton setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1-拷贝"] forState:UIControlStateNormal];
        [self.contentView addSubview:bigButton];
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        _iconImageView = iconImageView;
        iconImageView.image = [UIImage imageNamed:@"订单结果1"];
        [self.contentView addSubview:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        _titleLabel = titleLabel;
        _titleLabel.font = [UIFont systemFontOfSize:15*AutoSizeScaleX];
        titleLabel.textColor = [UIColor colorWithHexString:@"5eb5fd"];
        [self.contentView addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        _timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:11*AutoSizeScaleX];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:timeLabel];

        
        
    }
    return self;

}
-(void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    _titleLabel.text = self.contentString;

}
-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
 
    _timeLabel.text = _timeString;

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
    bigBtn.frame = CGRectMake(40, 10, kScreenWidth-40-10,75);
    _iconImageView.frame = CGRectMake(59, 20, 49, 49);
    _titleLabel.frame = CGRectMake(67+49, 20, 150, 50);
    _timeLabel.frame = CGRectMake(kScreenWidth-60-10-10, 20, 60, 50);

}
/**
 *  if you're using frame layout mode, you must override -sizeThatFits: in your customized cell
 *
 *  @param size size
 *
 *  @return 真实cell大小
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
