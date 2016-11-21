//
//  EnrollCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "EnrollCell.h"

@implementation EnrollCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.findDriverSchool setImage:[UIImage imageNamed:@"首页_1"] forState:UIControlStateNormal];
    [self.findCoachBtn setImage:[UIImage imageNamed:@"首页_2"] forState:UIControlStateNormal];
    [self.personalBtn setImage:[UIImage imageNamed:@"首页_3"] forState:UIControlStateNormal];
    [self.selfTestBtn setImage:[UIImage imageNamed:@"首页_4"] forState:UIControlStateNormal];
}

-(void)setImagesModel:(NSMutableArray *)imagesModel {
    _imagesModel = imagesModel;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<imagesModel.count; i++) {
        BannerImageModel *model = imagesModel[i];
        [arr addObject:model.imgUrl];
    }
    CGRect rect = CGRectMake(0,0, kScreenWidth, 0.283*kScreenWidth);
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:rect imageURLStringsGroup:arr];
    [self.contentView addSubview:self.bannerView];
    
    self.bannerView.placeholderImage = [UIImage imageNamed:@"默认banner"];
    self.bannerView.autoScrollTimeInterval = 3.0f;
    self.bannerView.delegate = self;
    self.bannerView.infiniteLoop = YES;
    self.bannerView.autoScroll = YES;
    self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.bannerView.pageControlDotSize = CGSizeMake(10, 10);
    self.bannerView.showPageControl = YES;
    self.bannerView.hidesForSinglePage = YES;
    self.bannerView.currentPageDotColor = [UIColor whiteColor];
    self.bannerView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(enrollCell:didSelectBannerItemAtIndex:)]) {
        [self.delegate enrollCell:self didSelectBannerItemAtIndex:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)enrollBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enrollCellDidClickBtnWithBtnType:)]) {
        [self.delegate enrollCellDidClickBtnWithBtnType:EnrollCellBtnBaoMingBtn];
    }
}

- (IBAction)findDriverSchoolBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enrollCellDidClickBtnWithBtnType:)]) {
        [self.delegate enrollCellDidClickBtnWithBtnType:EnrollCellBtnfindDriverSchool];
    }
}

- (IBAction)findCoachBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enrollCellDidClickBtnWithBtnType:)])  {
        [self.delegate enrollCellDidClickBtnWithBtnType:EnrollCellBtnfindCoachBtn];
    }
}

- (IBAction)personalBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enrollCellDidClickBtnWithBtnType:)])  {
        [self.delegate enrollCellDidClickBtnWithBtnType:EnrollCellBtnpersonalBtn];
    }
}

- (IBAction)selfTestBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enrollCellDidClickBtnWithBtnType:)])  {
        [self.delegate enrollCellDidClickBtnWithBtnType:EnrollCellBtnselfTestBtn];
    }
}

@end
