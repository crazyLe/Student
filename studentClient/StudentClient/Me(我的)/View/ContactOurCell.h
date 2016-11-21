//
//  ContactOurCell.h
//  KKXC_Franchisee
//
//  Created by gaobin on 16/8/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ContactOurCellPhoneClicked)(NSString *phoneNum); // 打电话

@interface ContactOurCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *customerServiceLab;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLab;

@property (nonatomic, copy) ContactOurCellPhoneClicked phoneClickedHandle;

@end
