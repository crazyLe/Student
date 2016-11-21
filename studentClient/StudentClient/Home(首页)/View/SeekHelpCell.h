//
//  SeekHelpCell.h
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SeekHelpCell;
@protocol  SeekHelpCellDelegate <NSObject>

-(void)seekHelpCellDidClickSendBtn:(SeekHelpCell *)cell;

@end

@interface SeekHelpCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UILabel * seekHelpLab;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * upMarkImgView;
@property (nonatomic, strong) UIImageView * downMarkImgView;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UIButton * sendBtn;
@property(nonatomic,weak)id<SeekHelpCellDelegate> delegate;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * placeLab;

/**
 *  科目几
 */
@property(nonatomic,strong)NSString *subjectNumber ;



@end
