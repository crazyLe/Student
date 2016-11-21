//
//  SafeRightsCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafeRightModel.h"

@protocol SafeRightsCellDelegate <NSObject>

- (void)clickSafeRightsCellPhoneBtn:(NSString *)telPhone;

@end

@interface SafeRightsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic ,assign) id<SafeRightsCellDelegate> delegate;

@property (nonatomic, strong) SafeRightModel * model;

@end
