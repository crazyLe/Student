//
//  SubjectExamPopView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopItemRowView.h"


typedef void(^ShowCompletionBlock) ();
typedef void(^DismissCompletionBlock) ();

typedef void(^ClickRowViewBlock) (PopItemRowView *rowView,NSMutableArray *classTypeNumArray);


@interface SubjectExamPopView : UIView

@property(nonatomic,strong)NSMutableArray * itemArray;

@property(nonatomic,strong)UIViewController * contentController;

-(void)showWithCompletionBlock:(ShowCompletionBlock)block;

-(void)dismissWithDismissCompletionBlock:(DismissCompletionBlock)block;

@property(nonatomic,strong)NSMutableArray * classTypeTitleArray;

@property(nonatomic,strong)NSMutableArray * classTypeNumArray;

@property(nonatomic,copy)ClickRowViewBlock clickItemBlock;


@end

