//
//  SubjectTwoRealCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectTwoRealCell : UITableViewCell
- (IBAction)testSimulateBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testSimulaterBtn;
@property(nonatomic,strong)NSDictionary * dict;



@end
