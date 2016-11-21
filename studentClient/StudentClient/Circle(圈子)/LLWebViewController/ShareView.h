//
//  ShareView.h
//  Coach
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {


    ShareViewBtnWeChatQuan = 0,
    
    ShareViewBtnWeChat,
    
    ShareViewBtnWeBo,
    
    ShareViewBtnQQZone,
    
    

}ShareViewBtnType;

@class ShareView;

typedef void(^ShareViewDismiss) (ShareView *view);

@protocol ShareViewDelegate <NSObject>

-(void)shareView:(ShareView *)shareView didClickButtonWithType:(ShareViewBtnType)type;

-(void)shareViewDidClickCancelButton:(ShareView *)shareView;


@end


@interface ShareView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant5;
- (IBAction)btn1Click:(id)sender;
- (IBAction)btn2Click:(id)sender;
- (IBAction)btn3Click:(id)sender;
- (IBAction)btn4Click:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong) id object;

-(void)show;

-(void)dismissWithCompletionBlock:(ShareViewDismiss)block;

@property(nonatomic,weak)id<ShareViewDelegate> delegate;


@end
