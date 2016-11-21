//
//  ChatBarContainer.h
//  Hrland
//
//  Created by Tousan on 15/9/18.
//  Copyright (c) 2015年 Tousan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ChatBarTextView.h"

@class ChatBarContainer;

@protocol ChatBarContainerDelegate <NSObject>

@optional

- (void)ChatBarContainer:(ChatBarContainer *)chatBar clickSendWithContent:(NSString*)content;
- (void)chatBarDidBecomeActive;

@end

@interface ChatBarContainer : UIView <UITextViewDelegate>

@property(nonatomic,strong)ChatBarTextView *txtView;
@property(nonatomic,strong)UIButton *send_Btn;
@property(nonatomic,strong)id<ChatBarContainerDelegate>myDelegate;
@property(nonatomic,assign)int max_Count;

@property(nonatomic,strong)id object;  //携带的对象

@property(nonatomic,strong)NSDictionary *userInfo;

- (void)textViewDidChange:(UITextView *)textView;

@end
