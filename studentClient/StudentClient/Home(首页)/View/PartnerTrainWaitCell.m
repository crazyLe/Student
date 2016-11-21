//
//  PartnerTrainWaitCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainWaitCell.h"

@implementation PartnerTrainWaitCell
{
    NSMutableArray *_topImageArray;
    UIImageView *middleImageView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.backgroundColor = BG_COLOR;

        _topImageArray = [NSMutableArray array];
        for (int i = 0; i<2; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor colorWithHexString:@"5eb5fd"];
            [self.contentView addSubview:imageView];
            [_topImageArray addObject:imageView];
        }
        middleImageView = [[UIImageView alloc]init];
        middleImageView.image = [UIImage imageNamed:@"订单结果che"];
        middleImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:middleImageView];
        
        UIButton *bigButton = [[UIButton alloc]init];
        _bigBtn = bigButton;
        bigButton.userInteractionEnabled = NO;
        [bigButton setBackgroundColor:[UIColor clearColor ]];
        [bigButton setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
        bigButton.titleLabel.font = [UIFont systemFontOfSize:15*AutoSizeScaleX];
        bigButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bigButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0,0);
        bigButton.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:bigButton];

        
        
    }
    
    return self;

}
-(void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    [_bigBtn setTitle:self.contentString forState:UIControlStateNormal];

}
-(void)layoutSubviews
{

    [super layoutSubviews];
    
    for (int i = 0; i<_topImageArray.count; i++) {
        UIImageView *imageView = _topImageArray[i];
        imageView.frame = CGRectMake(20, (3+8)*i, 3, 3);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.width/2;
    }
    
    middleImageView.frame = CGRectMake(4, 13,35, 34);
    _bigBtn.frame = CGRectMake(40, 10, kScreenWidth-40-10,35);

    



}
-(CGSize)sizeThatFits:(CGSize)size
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(_bigBtn.frame);
    return CGSizeMake(size.width,height);

}

@end
