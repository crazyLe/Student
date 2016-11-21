//
//  LLStudentTaskCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLStudentTaskCell.h"

@implementation LLStudentTaskCell

- (void)setUI
{
    [super setUI];
    _taskProgressLbl = [UILabel new];//任务进度
    [self.bgView addSubview:_taskProgressLbl];
    
    _alreadyReceiveLbl = [UILabel new];//已领
    [self.bgView addSubview:_alreadyReceiveLbl];
    
    _canReceiveLbl  = [UILabel new];//可领
    [self.bgView addSubview:_canReceiveLbl];
    
    //继续任务
    _progressView = [[LLProgressView alloc] initWithFrame:CGRectMake(10*kWidthScale+5+75, 43, 165*[UIScreen mainScreen].bounds.size.height/736.0, 50)];
    [self.bgView addSubview:_progressView];
}

- (void)setContraints
{
    [super setContraints];
    WeakObj(_taskProgressLbl)
    WeakObj(_alreadyReceiveLbl)
    __weak UILabel * _titleLblWeak = self.titleLbl;
    [_taskProgressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    [_alreadyReceiveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak);
        make.top.equalTo(_taskProgressLblWeak.mas_bottom).offset(10);
        make.width.offset(140);
        make.height.equalTo(_taskProgressLblWeak);
    }];
    
    [_canReceiveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alreadyReceiveLblWeak.mas_right).offset(5);
        make.top.height.width.equalTo(_alreadyReceiveLblWeak);
    }];
    
}

- (void)setAttributes
{
    [super setAttributes];
    
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    
    self.titleLbl.textColor = self.leftView.backgroundColor;
    
    _taskProgressLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _taskProgressLbl.font = kFont12;
    
    _alreadyReceiveLbl.textColor = _taskProgressLbl.textColor;
    _alreadyReceiveLbl.font = _taskProgressLbl.font;
    
    _canReceiveLbl.textColor = _taskProgressLbl.textColor ;
    _canReceiveLbl.font = _taskProgressLbl.font;
    
}
/**
 *  自定义cell的高亮背景
 *
 *  @param highlighted highlighted
 *  @param animated    animated
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

    if (highlighted) {
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
    else
    {
        self.bgView.backgroundColor = [UIColor whiteColor];

    }
    
    [super setHighlighted:highlighted animated:animated];


}

@end
