//
//  ComfirmBtnCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComfirmBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
- (IBAction)comfirmBtnClick:(id)sender;

@end
