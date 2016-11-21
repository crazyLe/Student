//
//  SeekHelpCell.m
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SeekHelpCell.h"
#import "Masonry.h"

@implementation SeekHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSubjectNumber:(NSString *)subjectNumber
{
    _subjectNumber = subjectNumber;
    
    _seekHelpLab.text = [NSString stringWithFormat:@"科%@求助",self.subjectNumber];

    if (_textView.text.length == 0) {
        
        _placeLab.text = [NSString stringWithFormat:@"关于科目%@的任何问题,您可以在此编辑发送到学员圈求助",self.subjectNumber];

    }
    else
    {
        _placeLab.text = @"";
        [_upMarkImgView removeFromSuperview];
        [_downMarkImgView removeFromSuperview];
    }

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _seekHelpLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 100, 20)];
        _seekHelpLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _seekHelpLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_seekHelpLab];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
        [self addSubview:_lineView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 120)];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_textView];
        //创建占位Label
        _placeLab = [[UILabel alloc] init];
        _placeLab.font = [UIFont systemFontOfSize:14];
        _placeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        _placeLab.enabled = NO;
        _placeLab.text = @"关于科目一的任何问题,您可以在此编辑发送到学员圈求助";
        _placeLab.numberOfLines = 0;
        [_textView addSubview:_placeLab];
        [_placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25);
            make.top.offset(25);
            //make.right.offset(-25);
            make.width.offset(kScreenWidth - 50);

        }];
        
        
        _upMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, 12, 12)];
        _upMarkImgView.image = [UIImage imageNamed:@"“"];
        [_textView addSubview:_upMarkImgView];
        _downMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 24, 120-24, 12, 12)];
        _downMarkImgView.image = [UIImage imageNamed:@"”"];
        [_textView addSubview:_downMarkImgView];
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, kScreenWidth, 80)];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
        [self addSubview:_bgView];
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.frame = CGRectMake(30, 16, kScreenWidth - 60, 44);
        [_sendBtn setTitle:@"发到学员圈" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setBackgroundImage:[UIImage resizedImageWithName:@"发到学员圈"]forState:UIControlStateNormal];
        _sendBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 7, 0, 0);
        _sendBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_sendBtn setImage:[UIImage resizedImageWithName:@"iconfont-pinglun"] forState:UIControlStateNormal];
        [_bgView addSubview:_sendBtn];
  
        
    }
    return self;
}
-(void)sendBtnClick
{
    if ([self.delegate respondsToSelector:@selector(seekHelpCellDidClickSendBtn:)]) {
        [self.delegate seekHelpCellDidClickSendBtn:self];
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeLab.text = [NSString stringWithFormat:@"关于科目%@的任何问题,您可以在此编辑发送到学员圈求助",self.subjectNumber];
        [_textView addSubview:_downMarkImgView];
        [_textView addSubview:_upMarkImgView];
    }else {
        _placeLab.text = @"";
        [_upMarkImgView removeFromSuperview];
        [_downMarkImgView removeFromSuperview];
    }
}

@end
