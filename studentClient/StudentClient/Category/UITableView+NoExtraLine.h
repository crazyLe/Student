//
//  UITableView+NoExtraLine.h
//  小筛子
//
//  Created by zwz on 15/6/29.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoExtraLine)
/**
 *  设置TableView的额外分割线隐藏
 */
-(void)setExtraCellLineHidden;
/**
 *  设置TableView分割线全屏
 */
-(void)setCellLineFullInScreen;

@end
