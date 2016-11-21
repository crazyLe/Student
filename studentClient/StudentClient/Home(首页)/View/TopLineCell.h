//
//  TopLineCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BBCyclingLabel.h>

@class TopLineCell;

@protocol TopLineCellDelegate <NSObject>

-(void)topLineCell:(TopLineCell *)cell didClickCircleLabelWithDict:(NSDictionary *)dict;

@end

@interface TopLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BBCyclingLabel *cyclingLabel;
- (IBAction)moreBtnClick:(id)sender;
@property(nonatomic,strong)NSMutableArray * studentTopArray;

@property(nonatomic,weak)id<TopLineCellDelegate> delegate;

@end
