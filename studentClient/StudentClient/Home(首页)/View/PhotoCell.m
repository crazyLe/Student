//
//  PhotoCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellHeight = (kScreenWidth-16-4)/2 + 20 + 20 + 18 + 20;
    
    
    [self.imageBtn1 addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn2 addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn3 addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn4 addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn5 addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)imageBtnClick:(UIButton *)btn
{
    if (btn == self.imageBtn1) {
        if (_photoArray.count >= 1) {
            if ([self.delegate respondsToSelector:@selector(photoCell:didClickBtnWithUrl:)]) {
                [self.delegate photoCell:self didClickBtnWithUrl:_photoArray[0][@"url"]];
            }
        }
        
    }
    if (btn == self.imageBtn2) {
        if (_photoArray.count >= 2) {
            if ([self.delegate respondsToSelector:@selector(photoCell:didClickBtnWithUrl:)]) {
                [self.delegate photoCell:self didClickBtnWithUrl:_photoArray[1][@"url"]];
            }
        }
        
    }
    if (btn == self.imageBtn3) {
        if (_photoArray.count >= 3) {
            if ([self.delegate respondsToSelector:@selector(photoCell:didClickBtnWithUrl:)]) {
                [self.delegate photoCell:self didClickBtnWithUrl:_photoArray[2][@"url"]];
            }
        }
        
    }
    if (btn == self.imageBtn4) {
        if (_photoArray.count >= 4) {
            if ([self.delegate respondsToSelector:@selector(photoCell:didClickBtnWithUrl:)]) {
                [self.delegate photoCell:self didClickBtnWithUrl:_photoArray[3][@"url"]];
            }
        }
        
    }
    if (btn == self.imageBtn5) {
        if (_photoArray.count >= 5) {
            if ([self.delegate respondsToSelector:@selector(photoCell:didClickBtnWithUrl:)]) {
                [self.delegate photoCell:self didClickBtnWithUrl:_photoArray[4][@"url"]];
            }
        }

        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPhotoArray:(NSMutableArray *)photoArray
{
    _photoArray = photoArray;
    
    if (photoArray.count >= 1) {
        [self.imageBtn1 setBackgroundImageWithURL:photoArray[0][@"imgUrl"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"photo1"]];
    }
    if (photoArray.count >= 2) {
        [self.imageBtn2 setBackgroundImageWithURL:photoArray[1][@"imgUrl"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"photo1"]];
    }
    if (photoArray.count >= 3) {
        [self.imageBtn3 setBackgroundImageWithURL:photoArray[2][@"imgUrl"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"photo1"]];
    }
    if (photoArray.count >= 4) {
        [self.imageBtn4 setBackgroundImageWithURL:photoArray[3][@"imgUrl"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"photo1"]];
    }
    if (photoArray.count >= 5) {
        [self.imageBtn5 setBackgroundImageWithURL:photoArray[4][@"imgUrl"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"photo1"]];
    }

}

@end
