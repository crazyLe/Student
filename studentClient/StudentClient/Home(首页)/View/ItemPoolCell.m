//
//  ItemPoolCell.m
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ItemPoolCell.h"

@implementation ItemPoolCell

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
        
        _itemPoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_itemPoolBtn setImage:[UIImage imageNamed:@"iconfont-kaoshi"] forState:UIControlStateNormal];
        [_itemPoolBtn addTarget:self action:@selector(itemPoolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemPoolBtn];
        
        _onlineTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onlineTestBtn setImage:[UIImage imageNamed:@"iconfont-icon04"] forState:UIControlStateNormal];
        [_onlineTestBtn addTarget:self action:@selector(onlineTestBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_onlineTestBtn];
        
        _mistakeCollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mistakeCollectionBtn setImage:[UIImage imageNamed:@"iconfont-icowrongnotebook"] forState:UIControlStateNormal];
        [_mistakeCollectionBtn addTarget:self action:@selector(mistakeCollectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mistakeCollectionBtn];
        
        [_itemPoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.top.offset(20);
            make.width.equalTo(_onlineTestBtn.mas_width);
            make.height.equalTo(_onlineTestBtn.mas_width);
            make.right.equalTo(_onlineTestBtn.mas_left).offset(-40);
        }];
        [_onlineTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.width.equalTo(_mistakeCollectionBtn.mas_width);
            make.height.equalTo(_mistakeCollectionBtn.mas_width);
            make.right.equalTo(_mistakeCollectionBtn.mas_left).offset(-40);
            
        }];
        [_mistakeCollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.height.equalTo(_itemPoolBtn.mas_width);
            make.right.offset(-40);
            
        }];
        
        _itemPoolLab = [[UILabel alloc] init];
        _itemPoolLab.text = @"试题库";
        _itemPoolLab.font = [UIFont systemFontOfSize:14];
        _itemPoolLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_itemPoolLab];
        
        _onlineTestLab = [[UILabel alloc] init];
        _onlineTestLab.text = @"在线模考";
        _onlineTestLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _onlineTestLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_onlineTestLab];
        
        _mistakeCollectionLab = [[UILabel alloc] init];
        _mistakeCollectionLab.text = @"错题集";
        _mistakeCollectionLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _mistakeCollectionLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_mistakeCollectionLab];
        
        [_itemPoolLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_itemPoolBtn.mas_bottom).offset(0);
            make.centerX.equalTo(_itemPoolBtn);
        }];
        [_onlineTestLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (_onlineTestBtn.mas_bottom).offset(0);
            make.centerX.equalTo(_onlineTestBtn);
        }];
        [_mistakeCollectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mistakeCollectionBtn.mas_bottom).offset(0);
            make.centerX.equalTo(_mistakeCollectionBtn);
        }];
        
        
        
    }
    return self;
    
}
-(void)itemPoolBtnClick
{
    if ([self.delegate respondsToSelector:@selector(itemPoolCell:didClickButtonWithType:)]) {
        [self.delegate itemPoolCell:self didClickButtonWithType:ItemPoolCellButtonOne];
    }


}
-(void)onlineTestBtnClick
{
    if ([self.delegate respondsToSelector:@selector(itemPoolCell:didClickButtonWithType:)]) {
        [self.delegate itemPoolCell:self didClickButtonWithType:ItemPoolCellButtonTwo];
    }
    
}
-(void)mistakeCollectionBtnClick
{
    if ([self.delegate respondsToSelector:@selector(itemPoolCell:didClickButtonWithType:)]) {
        [self.delegate itemPoolCell:self didClickButtonWithType:ItemPoolCellButtonThree];
    }
    
}
@end
