//
//  KZADLunchView.h
//  IMYADLaunchDemo
//
//  Created by sky on 2016/9/27.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZADLunchView : UIView

@property (nonatomic, strong) UIView *dialogView;    // Dialog's container view
@property (nonatomic, strong) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, assign) BOOL closeOnTouchUpOutside; // Closes the AlertView when finger is lifted outside the bounds.
@property (nonatomic, assign) BOOL showXCloseButton;
@property (nonatomic, assign) BOOL hasGradientLayer;

- (id)init;
- (void)show;
- (void)close;

@end
