//
//  NoNetWorkView.h
//  wills
//
//  Created by ai_ios on 16/5/19.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoNetworkViewReloadDelegate <NSObject>

@optional
- (void)reloadButtonClick;

@end

@interface NoNetworkView : UIView

@property (nonatomic , assign) id<NoNetworkViewReloadDelegate>delegate;


@end
