//
//  CollectionViewCell.m
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Masonry.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _collectionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 83, 83)];
        [self addSubview:_collectionImgView];
        
        _collectionLab = [[UILabel alloc] initWithFrame:CGRectMake(111, 15, kScreenWidth - 111 - 17, 40)];
        _collectionLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _collectionLab.font = [UIFont systemFontOfSize:16];
        _collectionLab.numberOfLines = 0;
        [self addSubview:_collectionLab];
        
        _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(111, 70, 100, 18)];
        _dateLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        _dateLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateLab];
        
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.font = [UIFont systemFontOfSize:13];
        _numberLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        [self addSubview:_numberLab];
        [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_dateLab);
            make.right.offset(-17);
        }];
        
        _numberImgView = [[UIImageView alloc] init];
        _numberImgView.image = [UIImage imageNamed:@"iconfont-chakan"];
        [self addSubview:_numberImgView];
        [_numberImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_numberLab);
            make.right.equalTo(_numberLab.mas_left).offset(-5);
        }];
        
        
        
    }
    return self;
}
@end
