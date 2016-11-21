//
//  SuperTableViewCell.m
//  Coach
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SuperTableViewCell.h"

@implementation SuperTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        [self setContraints];
        [self setAttributes];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI
{
    
}

- (void)setContraints
{
    
}

- (void)setAttributes
{
    
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
