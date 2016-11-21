//
//  PToderSecondTableCell.h
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfo.h"
#import "OrderInfoModel.h"
@interface PToderSecondTableCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray * timeArray;

@property(nonatomic,strong)OrderInfoModel *infoModel;


@end
