//
//  TuCaoFooterCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TuCaoFooterCell;

@protocol TuCaoFooterCellDelegate <NSObject>

-(void)tuCaoFooterCellDidClickMoreBtn:(TuCaoFooterCell *)cell;

@end

@interface TuCaoFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *moreTuCaoBtn;
- (IBAction)moreTuCaoBtnClick:(id)sender;
@property(nonatomic,weak)id<TuCaoFooterCellDelegate> delegate;


@end
