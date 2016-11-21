//
//  CollectionViewCell.h
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * collectionImgView;
@property (nonatomic, strong) UILabel * collectionLab;
@property (nonatomic, strong) UILabel * dateLab;
@property (nonatomic, strong) UILabel * numberLab;
@property (nonatomic, strong) UIImageView * numberImgView;

@end
