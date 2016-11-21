//
//  EnrollCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "EnrollButton.h"
#import "BannerImageModel.h"

typedef enum {
    
    EnrollCellBtnfindDriverSchool = 0,
    EnrollCellBtnfindCoachBtn,
    EnrollCellBtnpersonalBtn,
    EnrollCellBtnselfTestBtn,
    EnrollCellBtnBaoMingBtn
    
}EnrollCellBtnType;

@class EnrollCell;

@protocol EnrollCellDelegate <NSObject>

- (void)enrollCellDidClickBtnWithBtnType:(EnrollCellBtnType)btnType;

- (void)enrollCell:(EnrollCell *)cell didSelectBannerItemAtIndex:(NSInteger)index;

@end

@interface EnrollCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@property (weak, nonatomic) IBOutlet UIButton *enrollBtn;//报名须知
@property (weak, nonatomic) IBOutlet EnrollButton *findDriverSchool;
@property (weak, nonatomic) IBOutlet EnrollButton *findCoachBtn;
@property (weak, nonatomic) IBOutlet EnrollButton *personalBtn;
@property (weak, nonatomic) IBOutlet EnrollButton *selfTestBtn;

@property (nonatomic, weak) id<EnrollCellDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *imagesModel;//轮播图片
- (IBAction)enrollBtnClick:(id)sender;
- (IBAction)findDriverSchoolBtnClick:(id)sender;
- (IBAction)findCoachBtnClick:(id)sender;
- (IBAction)personalBtnClick:(id)sender;
- (IBAction)selfTestBtnClick:(id)sender;

@end
