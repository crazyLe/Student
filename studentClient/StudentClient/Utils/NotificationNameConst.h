//
//  NotificationNameConst.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//
#ifndef NotificationNameConst_h
#define NotificationNameConst_h
#import <UIKit/UIKit.h>
//通知中心
UIKIT_EXTERN  NSString  * const kUpdateCircleNotification;

UIKIT_EXTERN  NSString  * const kRefreshWalletDataNotification;

UIKIT_EXTERN  NSString  * const kLocationChangeNotification;

UIKIT_EXTERN  NSString  * const kRefreshPersonInfoNotification;

UIKIT_EXTERN  NSString  * const kAuthenticationStateNotification;

UIKIT_EXTERN  NSString  * const kUpdateMainMsgRedPointNotification;

UIKIT_EXTERN  NSString  * const kWeiXinPayFailNotification;

UIKIT_EXTERN  NSString  * const kWeiXinPaySuccessNotification;

UIKIT_EXTERN  NSString  * const kMakeMsgIsReadNotification;

UIKIT_EXTERN  NSString  * const kRefreshMyCoachStateNotification;

UIKIT_EXTERN  NSString  * const kRefreshBeansShowNotification;

UIKIT_EXTERN NSString * StringFromCGPoint(CGPoint point);


#endif
