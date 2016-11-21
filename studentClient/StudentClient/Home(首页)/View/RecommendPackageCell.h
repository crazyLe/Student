//
//  RecommendPackageCell.h
//  StudentClient
//
//  Created by sky on 2016/9/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZRecommendPackage.h"

@class RecommendPackageCell;

typedef void (^RecommendPackageCellDidClicked)(RecommendPackageCell *cell); // 打电话

@interface RecommendPackageCell : UITableViewCell

@property (nonatomic, copy) RecommendPackageCellDidClicked cellClickedHandle;

- (void)configForRecommendPackage:(KZRecommendPackage *)recommendPackage;

@end
