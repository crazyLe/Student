//
//  CircleMainContentCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CircleMainContentCell.h"

@implementation CircleMainContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        //头像
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        //名字
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"718990"];
        self.nameLabel.font = kFont14;
        [self.contentView addSubview:self.nameLabel];
        //VIP
        self.vipImageView = [[UIImageView alloc]init];
        self.vipImageView.image = [UIImage imageNamed:@"圈子_iconfont-circle-renzheng-1"];
        [self.contentView addSubview:self.vipImageView];
        
        //置顶
        self.topBestBtn = [[UIButton alloc]init];
        [self.topBestBtn setBackgroundImage:[UIImage imageNamed:@"矩形zhiding-2"] forState:UIControlStateNormal];
        [self.topBestBtn setTitle:@"置顶" forState:UIControlStateNormal];
        self.topBestBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.contentView addSubview:self.topBestBtn];
        
        //内容
        self.contentLabel = [[YYLabel alloc]init];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = kFont15;
        [self.contentView addSubview:self.contentLabel];
        
        //时间
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        self.timeLabel.font = kFont11;
        self.timeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.timeLabel];
        
        //地址位置
        self.locationLabel = [[UILabel alloc]init];
        self.locationLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        self.locationLabel.font = kFont11;
        [self.contentView addSubview:self.locationLabel];
        
        //评论按钮
        self.commentBtn = [[UIButton alloc]init];
        [self.commentBtn setImage:[UIImage imageNamed:@"圈子_iconfont-circle-talk"] forState:UIControlStateNormal];
        self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.commentBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
        self.commentBtn.titleLabel.font = kFont11;
        [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.commentBtn];
        
        //赞按钮
        self.zanBtn = [[UIButton alloc]init];
        self.zanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.zanBtn setImage:[UIImage imageNamed:@"圈子_iconfont-circle-zan"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
        [self.zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.zanBtn.titleLabel.font = kFont11;
        [self.contentView addSubview:self.zanBtn];
        
        //线条
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        //神评大View
        self.perfectCommentView = [[UIView alloc]init];
        self.perfectCommentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        //神评头像
        self.commentIconImageView = [[UIImageView alloc]init];
        self.commentIconImageView.clipsToBounds = YES;
        //神评名字
        self.commentNameLabel = [[UILabel alloc]init];
        self.commentNameLabel.textColor = [UIColor colorWithHexString:@"718990"];
        self.commentNameLabel.font = kFont14;
        //神评时间
        self.commentTimeLabel = [[UILabel alloc]init];
        self.commentTimeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        self.commentTimeLabel.adjustsFontSizeToFitWidth = YES;
        self.commentTimeLabel.font = kFont11;
        //神评图
        self.perfectCommentImageView = [[UIImageView alloc]init];
        self.perfectCommentImageView.clipsToBounds = YES;
        self.perfectCommentImageView.image = [UIImage imageNamed:@"圈子_组-1-副本"];
        //神评赞
        self.commentZanBtn = [[UIButton alloc]init];
        self.commentZanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.commentZanBtn setImage:[UIImage imageNamed:@"圈子_iconfont-circle-zan"] forState:UIControlStateNormal];
        [self.commentZanBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
        [self.commentZanBtn addTarget:self action:@selector(commentZanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.commentZanBtn.titleLabel.font = kFont11;
        //神评内容
        self.commentContentLabel = [[YYLabel alloc]init];
        self.commentContentLabel.numberOfLines = 0;
        self.commentContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.commentContentLabel.font = kFont15;
        
        
        
    }
    
    return self;

}
-(void)commentZanBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(circleMainContentCell:didClickCommentZanBtnWithModel:)]) {
        [self.delegate circleMainContentCell:self didClickCommentZanBtnWithModel:self.circleFrameModel];
    }


}
-(void)zanBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(circleMainContentCell:didClickZanBtnWithModel:)]) {
        [self.delegate circleMainContentCell:self didClickZanBtnWithModel:self.circleFrameModel];
    }
    
}
-(void)commentBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(circleMainContentCell:didClickCommentBtnWithModel:)]) {
        [self.delegate circleMainContentCell:self didClickCommentBtnWithModel:self.circleFrameModel];
    }
    
}
-(void)setCircleFrameModel:(CircleMainFrameModel *)circleFrameModel
{
    _circleFrameModel = circleFrameModel;

    [self setupFrame];
    
    [self setupData];

}
-(void)setupFrame
{
    [self.imageViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imageViewsArray = [NSMutableArray array];
    self.iconImageView.frame = self.circleFrameModel.iconImageViewF;
    self.nameLabel.frame = _circleFrameModel.nameLabelF;
    self.vipImageView.frame = _circleFrameModel.vipImageViewF;
    self.topBestBtn.frame = _circleFrameModel.topBestImageViewF;
    self.contentLabel.frame = _circleFrameModel.contentLabelF;
    
    if (_circleFrameModel.circleMainModel.pic.count>0) {//有图片
        
        for (int i = 0; i<_circleFrameModel.imageViewFrameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            NSString *rectStr = _circleFrameModel.imageViewFrameArray[i];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+500;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
            imageView.frame =CGRectFromString(rectStr);
            [self.contentView addSubview:imageView];
            [self.imageViewsArray addObject:imageView];
        }
        
    }
    
    self.timeLabel.frame = self.circleFrameModel.timeLabelF;
    self.locationLabel.frame = self.circleFrameModel.locationLabelF;
    self.commentBtn.frame = self.circleFrameModel.commentBtnF;
    self.zanBtn.frame = self.circleFrameModel.zanBtnF;
    
    if(self.circleFrameModel.circleMainModel.comemnt.addtime != nil )//有评论
    {
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.perfectCommentView];
        [self.contentView addSubview:self.commentIconImageView];
        [self.contentView addSubview:self.commentNameLabel];
        [self.contentView addSubview:self.commentTimeLabel];
        [self.contentView addSubview:self.perfectCommentImageView];
        [self.contentView addSubview:self.commentZanBtn];
        [self.contentView addSubview:self.commentContentLabel];

        self.commentIconImageView.frame = self.circleFrameModel.commentIconImageViewF;
        self.commentNameLabel.frame = self.circleFrameModel.commentNameLabelF;
        self.commentTimeLabel.frame = self.circleFrameModel.commentTimeLabelF;
        self.perfectCommentImageView.frame = self.circleFrameModel.perfectCommentImageViewF;
        self.commentZanBtn.frame = self.circleFrameModel.commentZanBtnF;
        
        self.commentContentLabel.frame = self.circleFrameModel.commentContentLabelF;
        
        self.perfectCommentView.frame = self.circleFrameModel.perfectCommentViewF;
        self.lineView.frame = self.circleFrameModel.lineViewF;
        
    }
    else
    {
        [self.lineView removeFromSuperview];
        [self.perfectCommentView removeFromSuperview];
        [self.commentIconImageView removeFromSuperview];
        [self.commentNameLabel removeFromSuperview];
        [self.commentTimeLabel removeFromSuperview];
        [self.perfectCommentImageView removeFromSuperview];
        [self.commentZanBtn removeFromSuperview];
        [self.commentContentLabel removeFromSuperview];

    
    }

}
-(void)imageTap:(UITapGestureRecognizer *)tap
{
   
    NSInteger tag = tap.view.tag;
    
    NSString *urlStr =  _circleFrameModel.circleMainModel.pic[tag-500][@"imgpath"];
    
    if ([self.delegate respondsToSelector:@selector(circleMainContentCell:didClickImageViewWithImageUrl:index:)]) {
        [self.delegate circleMainContentCell:self didClickImageViewWithImageUrl:urlStr index:(int)tag-500];
    }

}
-(void)setupData
{
    if (self.circleFrameModel.circleMainModel.is_ver == 1)
    {
        self.vipImageView.hidden = NO;
    }
    else
    {
        self.vipImageView.hidden = YES;
    }
    if (self.circleFrameModel.circleMainModel.isTop == 1)
    {
        self.topBestBtn.hidden = NO;
    }
    else
    {
        self.topBestBtn.hidden = YES;
    }
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
    NSURL *url = [NSURL URLWithString:_circleFrameModel.circleMainModel.face];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = _circleFrameModel.circleMainModel.nickName;
    self.contentLabel.text = _circleFrameModel.circleMainModel.content;
    for (int i = 0; i<self.imageViewsArray.count; i++) {
        UIImageView *imageView = self.imageViewsArray[i];
        NSDictionary *dict = _circleFrameModel.circleMainModel.pic[i];
        NSString *str = dict[@"imgpath"];
        NSURL *url = [NSURL URLWithString:str];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认图片"]];
    }
    NSString *time = self.circleFrameModel.circleMainModel.addtime;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat  = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    self.timeLabel.text = [df stringFromDate:date];
    self.locationLabel.text = self.circleFrameModel.circleMainModel.area;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)self.circleFrameModel.circleMainModel.commentNum] forState:UIControlStateNormal];
    if (self.circleFrameModel.circleMainModel.is_praise==1) {//赞过
        [self.zanBtn setImage:[UIImage imageNamed:@"iconfont-circle-zan-拷贝"] forState:UIControlStateNormal];
    }
    else
    {
        [self.zanBtn setImage:[UIImage imageNamed:@"圈子_iconfont-circle-zan"] forState:UIControlStateNormal];
    }
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)self.circleFrameModel.circleMainModel.likeNum] forState:UIControlStateNormal];
    if(self.circleFrameModel.circleMainModel.comemnt.addtime != nil)//有评论
    {
        CircleCommentModel *commentModel =self.circleFrameModel.circleMainModel.comemnt;
        NSURL *url = [NSURL URLWithString:commentModel.face];
        self.commentIconImageView.layer.cornerRadius = self.commentIconImageView.width/2;
        [self.commentIconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
        self.commentNameLabel.text = commentModel.nickname;
        NSString *time = commentModel.addtime;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat  = @"yyyy-MM-dd";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
        self.commentTimeLabel.text = [df stringFromDate:date];
        if (self.circleFrameModel.circleMainModel.comemnt.is_praise==1) {//赞过
            [self.commentZanBtn setImage:[UIImage imageNamed:@"iconfont-circle-zan-拷贝"] forState:UIControlStateNormal];
        }
        else
        {
            [self.commentZanBtn setImage:[UIImage imageNamed:@"圈子_iconfont-circle-zan"] forState:UIControlStateNormal];
        }
        [self.commentZanBtn setTitle:[NSString stringWithFormat:@"%d",commentModel.likeNum] forState:UIControlStateNormal];
        self.commentContentLabel.text = commentModel.content;
    
    }

}


@end
