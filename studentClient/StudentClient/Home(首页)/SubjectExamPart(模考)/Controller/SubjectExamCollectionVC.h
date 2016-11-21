//
//  SubjectExamCollectionVC.h
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectExamController.h"
#import "BaseViewController.h"
@interface SubjectExamCollectionVC : BaseViewController

/**
 *  是否科目一
 */
@property(nonatomic,assign)BOOL isSubjectOne;
/**
 *  是否模考
 */
@property(nonatomic,assign)BOOL isExamination;

@property(nonatomic,strong)NSMutableArray * allDataArray;


@end
