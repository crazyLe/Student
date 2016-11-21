//
//  RecommendPackageCell.m
//  StudentClient
//
//  Created by sky on 2016/9/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RecommendPackageCell.h"

@interface RecommendPackageCell()

@property (weak, nonatomic) IBOutlet UILabel *locationLable;

@property (weak, nonatomic) IBOutlet UILabel *typeLable;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet UILabel *subTextLable;

@property (weak, nonatomic) IBOutlet UIButton *goDetailBtn;
- (IBAction)goDetailAction:(UIButton *)sender;

@end



@implementation RecommendPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goDetailBtn.layer.masksToBounds = YES;
    self.goDetailBtn.layer.cornerRadius = 4;
    self.locationLable.text = kCurrentLocationCity;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)configForRecommendPackage:(KZRecommendPackage *)recommendPackage {
    self.locationLable.text = kCurrentLocationCity;
    self.typeLable.text = recommendPackage.name;
    self.priceLable.text = [NSString stringWithFormat:@"¥%.0f",recommendPackage.price];
    NSArray *detailTexts = [recommendPackage.details componentsSeparatedByString:@";"];
    self.detailLable.text = detailTexts.firstObject;
    if (detailTexts.count > 1) {
        self.subTextLable.text = detailTexts.lastObject;
    }
}

- (IBAction)goDetailAction:(UIButton *)sender {
    if (self.cellClickedHandle) {
        self.cellClickedHandle(self);
    }
}
@end
