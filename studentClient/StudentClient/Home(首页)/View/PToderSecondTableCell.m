//
//  PToderSecondTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PToderSecondTableCell.h"

#define hSpacingNum 17.0

@implementation PToderSecondTableCell
{
    NSMutableArray *_rowViewArray;
    UIView *_totalView;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rowViewArray = [NSMutableArray array];
        [self createaUI];
    }
    return self;
}

- (void)createaUI
{
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 36, 15)];
    timeLabel.text = @"时间:";
    timeLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    timeLabel.font = [UIFont systemFontOfSize:15.0];
//    timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:timeLabel];
    
//    UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake(26+36, 5, kScreenWidth-80-16, 38)];
////    firstView.backgroundColor = [UIColor orangeColor];
//    [self.contentView addSubview:firstView];
//    
//    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, firstView.frame.size.width-26, 15)];
//    NSMutableAttributedString * attStr = nil;
//    attStr = [[NSMutableAttributedString alloc]initWithString:@"2016-06-30 09:00~10:00 " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥50" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#51aeff"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
//    firstLabel.attributedText = attStr;
////    firstLabel.backgroundColor = [UIColor magentaColor];
//    [firstView addSubview:firstLabel];
//    
//    UIImageView * firstArrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-58-62, 14, 12, 8)];
//    firstArrow.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
////    firstArrow.backgroundColor = [UIColor purpleColor];
//    [firstView addSubview:firstArrow];
//    
//    UIImageView * firstLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, firstView.frame.size.height-LINE_HEIGHT, firstView.frame.size.width-20, LINE_HEIGHT)];
//    firstLine.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
//    firstLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
//    [firstView addSubview:firstLine];
//    
//    
//    
//    UIView * secondView = [[UIView alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(firstView.frame), kScreenWidth-80-16, 38)];
////    secondView.backgroundColor = [UIColor yellowColor];
//    [self.contentView addSubview:secondView];
//    
//    UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, secondView.frame.size.width-26, 15)];
//    NSMutableAttributedString * secondStr = nil;
//    secondStr = [[NSMutableAttributedString alloc]initWithString:@"2016-06-30 09:00~10:00 " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    [secondStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥50" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#51aeff"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
//    secondLabel.attributedText = secondStr;
////    secondLabel.backgroundColor = [UIColor magentaColor];
//    [secondView addSubview:secondLabel];
//    
//    
//    UIImageView * secondArrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-58-62, 14, 12, 8)];
//    secondArrow.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
//    //    thirdArrow.backgroundColor = [UIColor purpleColor];
//    [secondView addSubview:secondArrow];
//    
//    UIImageView * secondLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, firstView.frame.size.height-LINE_HEIGHT, firstView.frame.size.width-20, LINE_HEIGHT)];
//    secondLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
//    [secondView addSubview:secondLine];
//    
//    
//    
//    UIView * thirdView = [[UIView alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(secondView.frame), kScreenWidth-80-16, 38)];
////    thirdView.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:thirdView];
//    
//    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, thirdView.frame.size.width-26, 15)];
//    NSMutableAttributedString * thirdStr = nil;
//    thirdStr = [[NSMutableAttributedString alloc]initWithString:@"总计：           2小时           " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥100" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#51aeff"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
//    thirdLabel.attributedText = thirdStr;
////    thirdLabel.backgroundColor = [UIColor magentaColor];
//    [thirdView addSubview:thirdLabel];
    
}
-(void)setTimeArray:(NSMutableArray *)timeArray
{
    _timeArray = timeArray;
    
    [_totalView removeFromSuperview];
    
    [_rowViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _rowViewArray = [NSMutableArray array];
    
    for (int i = 0; i<timeArray.count; i++) {
      
        ProductInfo *infoModel = timeArray[i];
        
        UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake(26+36, 5+(38)*i, kScreenWidth-80-16, 45)];
        //    firstView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:firstView];
        
        UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, firstView.frame.size.width-26, 15)];
//        NSMutableAttributedString * attStr = nil;
        firstLabel.text = infoModel.content;
        firstLabel.font = [UIFont systemFontOfSize:13];
        firstLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        attStr = [[NSMutableAttributedString alloc]initWithString:@"2016-06-30 09:00~10:00 " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥50" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#51aeff"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
//        firstLabel.attributedText = attStr;
        //    firstLabel.backgroundColor = [UIColor magentaColor];
        [firstView addSubview:firstLabel];
        
        UIImageView * firstArrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-58-62, 14, 12, 8)];
        firstArrow.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
        //    firstArrow.backgroundColor = [UIColor purpleColor];
        [firstView addSubview:firstArrow];
        
        UIImageView * firstLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, firstView.frame.size.height-LINE_HEIGHT, firstView.frame.size.width-20, LINE_HEIGHT)];
        firstLine.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
        firstLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [firstView addSubview:firstLine];
        
        [_rowViewArray addObject:firstView];
        

        
    }
    ProductInfo *infoModel = nil;
    if (timeArray.count>0) {
        
        infoModel = timeArray[0];

    }

    
    UIView *lastView = _rowViewArray.lastObject;
    
    
    UIView * thirdView = [[UIView alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(lastView.frame), kScreenWidth-80-16, 45)];
    
    _totalView = thirdView;
    //    thirdView.backgroundColor = [UIColor blueColor];
    
    [self.contentView addSubview:thirdView];
    
    
    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, thirdView.frame.size.width-26, 15)];
    
    NSMutableAttributedString * thirdStr = nil;
    
    thirdStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"总计：           %d小时           ",infoModel.totaltime] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_infoModel.totalMoney] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#51aeff"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    
    thirdLabel.attributedText = thirdStr;
    //    thirdLabel.backgroundColor = [UIColor magentaColor];
    
    [thirdView addSubview:thirdLabel];
    
   

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
