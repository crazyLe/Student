//
//  LLMoreFilterCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LLMoreFilterCellTypeRadio = 1,
    LLMoreFilterCellTypeMultiSelect
}LLMoreFilterCellType;

@interface LLMoreFilterCell : SuperTableViewCell

@property (nonatomic,strong) UILabel *titleLbl;

@property (nonatomic,strong) UIButton *helpBtn;

@property (nonatomic,strong) NSMutableArray *filterBtnArr;

@property (nonatomic,strong) NSMutableDictionary *filterSelectDic;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) LLMoreFilterCellType type;

- (void)setContentWithType:(LLMoreFilterCellType)type;

@end
