//
//  SendMsgToolBar.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SendMsgToolBarCameraBtn = 0,
    SendMsgToolBarPhotoBtn ,
    SendMsgToolBarNimingBtn
} SendMsgToolBarButtonType;

@class SendMsgToolBar;

@protocol SendMsgToolBarDelegate <NSObject>

-(void)sendMsgToolBar:(SendMsgToolBar *)toolBar didClickButtonType:(SendMsgToolBarButtonType)type;

@end

@interface SendMsgToolBar : UIView
- (IBAction)cameraBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
- (IBAction)photoBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
- (IBAction)nimingSwitchClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *nimingSwitch;
@property(nonatomic,weak)id<SendMsgToolBarDelegate> delegate;

@end
