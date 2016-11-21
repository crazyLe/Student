//
//  TuCaoFooterCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "TuCaoFooterCell.h"

@implementation TuCaoFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreTuCaoBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tuCaoFooterCellDidClickMoreBtn:)]) {
        [self.delegate tuCaoFooterCellDidClickMoreBtn:self];
    }
 
}
@end
