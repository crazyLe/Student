//
//  InviteMsgCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InviteMsgCell;
@protocol  InviteMsgCellDelegate<NSObject>

// 0 拒绝 1同意
-(void)inviteMsgCell:(InviteMsgCell *)cell didClickAgreeOrRejectBtnWithString:(NSString *)str;

@end

@interface InviteMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeBtnClick:(id)sender;
- (IBAction)rejectBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) id<InviteMsgCellDelegate> delegate;
@property(nonatomic,strong)NSString *inviteId;
@end
