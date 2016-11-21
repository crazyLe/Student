//
//  SubjectThreeVideoCell.m
//  学员端
//
//  Created by gaobin on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectThreeVideoCell.h"
#import "Masonry.h"

#define CELLWIDTH (kScreenWidth-26)
#define aspect  0.7

@implementation SubjectThreeVideoCell
{
    
    NSMutableArray * videoItemViewArray;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellUIWithVideoModelArray:(NSMutableArray *)videoModelArray
{
    
    [videoItemViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    videoItemViewArray = [NSMutableArray array];
    
    for (int i = 0; i<videoModelArray.count; i++) {
        
        SubjectVideoItem *itemView = [[SubjectVideoItem alloc]init];
        
        itemView.itemModel = videoModelArray[i];
        
        itemView.delegate = self;
        
        [self.contentView addSubview:itemView];
        
        [videoItemViewArray addObject:itemView];
        
        
    }
    

  
}
-(void)subjectVideoItem:(SubjectVideoItem *)itemView didClickContentBtnWithModel:(SubjectVideoModel *)model
{
    if ([self.delegate respondsToSelector:@selector(subjectThreeVideoCell:didClickItemViewWithItemModel:)])
    {
        [self.delegate subjectThreeVideoCell:self didClickItemViewWithItemModel:model];
    }
    
    
}
+(CGFloat)getCellHeightWithData:(NSMutableArray *)data
{
    
    NSInteger totalRow = (data.count+1)/2;
    
     return 10+(((float)CELLWIDTH/2)*aspect+10)*totalRow+20;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    

    for (int i = 0; i<videoItemViewArray.count; i++) {
        
        int row = i/2;
        
        int col = i%2;
        
        SubjectVideoItem *itemView = videoItemViewArray[i];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(col*((float)CELLWIDTH/2)+13));
            make.top.equalTo(@(10+(((float)CELLWIDTH/2)*aspect+10)*row));
            make.size.mas_equalTo(CGSizeMake((float)CELLWIDTH/2,  ((float)CELLWIDTH/2)*aspect));
        }];
        
        
    }
    
    
}

@end
