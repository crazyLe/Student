//
//  SubjectTwoVideoCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectTwoVideoCell.h"
#define CELLWIDTH (kScreenWidth-26)
#define aspect  0.7
@implementation SubjectTwoVideoCell
{

    NSMutableArray *videoItemViewArray;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //蓝色线条
        self.lineLabel = [[UILabel alloc]init];
        
        self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#5cb6fd"];
        
        [self.contentView addSubview:self.lineLabel];
        
        //title
    
        self.titleLabel = [[UILabel alloc]init];
        
        self.titleLabel.text = @"教学视频";
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#636363"];
        
        [self.contentView addSubview:self.titleLabel];
  
    }

    return self;



}
+(CGFloat)getCellHeightWithData:(NSMutableArray *)data
{

    NSInteger totalRow = (data.count+1)/2;
    
    return 38+10+(((float)CELLWIDTH/2)*aspect+10)*totalRow+20;

}

-(void)configCellUIWithVideoModelArray:(NSMutableArray *)videoModelArray
{
    if (videoModelArray == self.videoModelArray) return;

    [videoItemViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];

    videoItemViewArray = [NSMutableArray array];

    for (int i = 0; i<videoModelArray.count; i++) {
        
        SubjectVideoItem *itemView = [[SubjectVideoItem alloc]init];
        itemView.delegate = self;
        itemView.itemModel = videoModelArray[i];
        
        [self.contentView addSubview:itemView];
        
        [videoItemViewArray addObject:itemView];
        
        
    }


   

}
-(void)subjectVideoItem:(SubjectVideoItem *)itemView didClickContentBtnWithModel:(SubjectVideoModel *)model
{
    if ([self.delegate respondsToSelector:@selector(subjectTwoVideoCell:didClickItemViewWithItemModel:)]) {
        [self.delegate subjectTwoVideoCell:self didClickItemViewWithItemModel:model];
    }
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        
        make.top.offset(20);
        
        make.size.mas_equalTo(CGSizeMake(5, 18));
  
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lineLabel.mas_right).offset(8);
        
        make.centerY.equalTo(self.lineLabel.mas_centerY);
        
        make.height.equalTo(@26);
  
    }];
    
    
    
    for (int i = 0; i<videoItemViewArray.count; i++) {
        
        int row = i/2;
        
        int col = i%2;
        
        SubjectVideoItem *itemView = videoItemViewArray[i];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(col*((float)CELLWIDTH/2)+13));
            make.top.equalTo(@(46+10+(((float)CELLWIDTH/2)*aspect+10)*row));
            make.size.mas_equalTo(CGSizeMake((float)CELLWIDTH/2,  ((float)CELLWIDTH/2)*aspect));
        }];
        
        
    }
        
   
    
    
    




}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
