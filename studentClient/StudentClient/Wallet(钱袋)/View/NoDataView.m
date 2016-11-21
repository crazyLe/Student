//
//  NoDataView.m
//  wills
//
//  Created by ai_ios on 16/5/10.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import "NoDataView.h"
#define TextBlackColor  RGBCOLOR(51, 51, 51) //黑色字体颜色
#define TextGrayColor RGBCOLOR(165, 165, 165)  //灰色字体颜色

@interface NoDataView () {
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation NoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BG_COLOR;
        [self initSubviews];
    }
    return self ;
}

- (void)initSubviews
{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nodata"]] ;
    [self addSubview:_imageView];
    CGSize imgSize = [UIImage imageNamed:@"icon_nodata"].size ;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(self.center.x, self.center.y-imgSize.height/2));
        make.size.mas_equalTo(imgSize);
        
    }];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = Font14;
    _titleLabel.textColor = TextGrayColor;
    _titleLabel.text = @"还没有相关信息";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
 
}


@end
