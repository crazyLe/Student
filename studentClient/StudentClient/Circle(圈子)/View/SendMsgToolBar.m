//
//  SendMsgToolBar.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SendMsgToolBar.h"

@implementation SendMsgToolBar

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.nimingSwitch.onTintColor = [UIColor colorWithHexString:@"5eb5fc"];
}

- (IBAction)cameraBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendMsgToolBar:didClickButtonType:)]) {
        [self.delegate sendMsgToolBar:self didClickButtonType:SendMsgToolBarCameraBtn];
    }
}
- (IBAction)photoBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendMsgToolBar:didClickButtonType:)]) {
        [self.delegate sendMsgToolBar:self didClickButtonType:SendMsgToolBarPhotoBtn];
    }

}
- (IBAction)nimingSwitchClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(sendMsgToolBar:didClickButtonType:)]) {
        [self.delegate sendMsgToolBar:self didClickButtonType:SendMsgToolBarNimingBtn];
    }

}
@end
