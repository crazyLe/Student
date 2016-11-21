//
//  SubjectTwoVideoItem.m
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectVideoItem.h"

@implementation SubjectVideoItem
/**
 *  代码创建
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if (self = [super init]) {
        
        [self setupSubviews];
        
    }
    
    return self;

}
/**
 *  XIB创建
 *
 *  @param aDecoder aDecoder
 *
 *  @return instancetype
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupSubviews];

    }
    return self;
}
-(void)setItemModel:(SubjectVideoModel *)itemModel
{
    _itemModel = itemModel;
    
    
    self.mainTitleLabel.text = self.itemModel.title;
    
    if ([itemModel isKindOfClass:[SubjectVideoModel class]]) {
        
        [self.contentButton setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.itemModel.imgUrl]] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"4x3比例"]];

        self.timeLabel.text = [NSString stringWithFormat:@"%lld",self.itemModel.time];

    }
    else
    {
        [self.contentButton setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.itemModel.imgUrl]] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"4x3比例"]];

        
    }

}
-(void)conentBtnClick
{
    if ([self.delegate respondsToSelector:@selector(subjectVideoItem:didClickContentBtnWithModel:)]) {
        [self.delegate subjectVideoItem:self didClickContentBtnWithModel:self.itemModel];
    }
    
}
-(void)setupSubviews
{
    self.contentButton = [[UIButton alloc]init];
    
    [self.contentButton addTarget:self action:@selector(conentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.contentButton];
    
    self.mainTitleLabel = [[UILabel alloc]init];
    
    self.mainTitleLabel.font = [UIFont systemFontOfSize:13];
    
    self.mainTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    [self addSubview:self.mainTitleLabel];
    
    
    self.timeLabel = [[UILabel alloc]init];
    
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    [self addSubview:self.timeLabel];
    
    
    self.timeImageView = [[UIImageView alloc]init];
    
    self.timeImageView.image = [UIImage imageNamed:@"timeImageView"];
    
    [self addSubview:self.timeImageView];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(8);
        
        make.right.equalTo(self.mas_right).offset(-8);
        
        make.top.equalTo(self.mas_top).offset(0);
        
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        
        
    }];
  
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-8);
        make.left.equalTo(self.timeImageView.mas_right).offset(4);
        make.centerY.equalTo(self.mainTitleLabel.mas_centerY);
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentButton).offset(0);
        make.top.equalTo(self.contentButton.mas_bottom).offset(3);
        make.height.equalTo(@20);
        make.right.lessThanOrEqualTo(self.timeImageView.mas_left).offset(0);
        
    }];
    
    
    
    
    
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainTitleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    

   
    
  

}

@end
