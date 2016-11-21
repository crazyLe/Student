//
//  HJInterfaceManager.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//  项目接口文档

#import <Foundation/Foundation.h>


#define TESTBASICURL @"http://192.168.5.216:81/index.php/student"//注释掉就是正式版，打开就是测试版
#ifndef TESTBASICURL
#define TESTBASICURL @"https://www.kangzhuangxueche.com/index.php/student"
#endif

#define TESTWEB_BASICURL @"http://192.168.5.216:81/index.php/wap"//注释掉就是正式版，打开就是测试版
#ifndef TESTWEB_BASICURL
#define TESTWEB_BASICURL @"https://www.kangzhuangxueche.com/index.php/wap"
#endif


@interface HJInterfaceManager : NSObject

singletonInterface(HJInterfaceManager)

@property(nonatomic, copy) NSString *loginUrl; ///登录

@property(nonatomic, copy) NSString *getRegisterCode;

@property(nonatomic, copy) NSString *registerUrl;

@property(nonatomic, copy) NSString *searchSchools; ///找驾校

@property(nonatomic, copy) NSString *mainUrl;

@property(nonatomic, copy) NSString *subjectThird;

@property(nonatomic, copy) NSString *searchCoachs;

@property(nonatomic, copy) NSString *subjectsMainPage;///科目一四

@property(nonatomic, copy) NSString *getAddressUrl;

@property(nonatomic, copy) NSString *partnerTrainUrl;///学时陪练

@property(nonatomic, copy) NSString *examAreaUrl;///科二、科三场地模考

@property(nonatomic, copy) NSString *coachsSerachTagUrl;

@property(nonatomic, copy) NSString *questionsCommentList;

@property(nonatomic, copy) NSString *questionSayUrl;

@property(nonatomic, copy) NSString *vouchersList; ///代金券列表

@property(nonatomic, copy) NSString *reveiveVouchers; ///领取代金券

@property(nonatomic, copy) NSString *getMypurseUrl;   //钱袋

@property(nonatomic, copy) NSString *myVoucher; ///我的代金券

@property(nonatomic, copy) NSString *getOrderinfo;    //分期账单还款界面

@property(nonatomic, copy) NSString *submitPersonalInfo; //保存个人设置

@property(nonatomic, copy) NSString *myOrderList; //我的订单,订单列表

@property(nonatomic, copy) NSString *getErrorRate;

@property(nonatomic, copy) NSString *realNameState; ///实名认证状态

@property(nonatomic, copy) NSString *synchronousScoreUrl;

@property(nonatomic, copy) NSString *memberInfo; ///个人信息

@property(nonatomic, copy) NSString *getRepayment;

@property(nonatomic, copy) NSString *communityCreateUrl;
//我的教练
@property(nonatomic, copy) NSString *myCoach;
//检索我的教练列表
@property(nonatomic, copy) NSString *mineCoach;
//绑定教练
@property(nonatomic, copy) NSString *bindingCoach;
//解除绑定教练
@property(nonatomic, copy) NSString *getValidationAmount;

@property(nonatomic, copy) NSString *getEditPassword;

@property(nonatomic, copy) NSString *getSendCode;   //获取验证码

@property(nonatomic, copy) NSString *getEditPhone;

@property(nonatomic, copy) NSString *getFend;

@property(nonatomic, copy) NSString *getMemberInfo;

@property(nonatomic, copy) NSString *getCommunity;

@property(nonatomic, copy) NSString *getCancelorder;

@property(nonatomic, copy) NSString *memberCommunityList;

@property(nonatomic, copy) NSString *createCommunity;

@property(nonatomic, copy) NSString *communitySubmitPics;

@property(nonatomic, copy) NSString *userPics; //上传用户头像

@property(nonatomic, copy) NSString *getOrderdetails;

@property(nonatomic, copy) NSString *unBindCoachUrl;

@property(nonatomic, copy) NSString *userAuthAddUrl;

@property(nonatomic, copy) NSString *zixueUrl;

@property(nonatomic, copy) NSString *enlistnoticUrl;

@property(nonatomic, copy) NSString *beansHowGet;

@property(nonatomic, copy) NSString *beansRule;

@property(nonatomic, copy) NSString *getCashUrl;//提现

@property(nonatomic, copy) NSString *xueFeiTaskUrl;

@property(nonatomic, copy) NSString *personalInfoUrl;

@property(nonatomic, copy) NSString *teachingDetailUrl;

@property(nonatomic, copy) NSString *changeTeachingUrl;

@property(nonatomic, copy) NSString *circleDetailUrl;

@property(nonatomic, copy) NSString *rankUrl;

@property(nonatomic, copy) NSString *weiMingPianUrl;

@property(nonatomic, copy) NSString *loadOrderUrl;

@property(nonatomic, copy) NSString *personalUrl;

@property(nonatomic, copy) NSString *submitOrder;

@property(nonatomic, copy) NSString *payOrder;

@property(nonatomic, copy) NSString *memberCommunity;

@property(nonatomic, copy) NSString *testRecordUrl;

@property(nonatomic, copy) NSString *getCashCasebefore;

@property(nonatomic, copy) NSString *memberRecharge;

@property(nonatomic, copy) NSString *mypurseBill;

@property(nonatomic, copy) NSString *memberShare;

@property(nonatomic, copy) NSString *msgUrl;

@property(nonatomic, copy) NSString *payResultUrl;

@property(nonatomic, copy) NSString *getCarUrl;

@property(nonatomic, copy) NSString *fenQiUrl;

@property(nonatomic, copy) NSString *relativeAdd;

@property(nonatomic, copy) NSString *testRecordDelUrl;

@property(nonatomic, copy) NSString *checkVersion;

@property(nonatomic, copy) NSString *fenqiSubmitOrder;

@property(nonatomic, copy) NSString *commentLikeUrl;

@property(nonatomic, copy) NSString *subjectThirdExamplace;

@property(nonatomic, copy) NSString *agreementUrl;

@property(nonatomic, copy) NSString *recruitUpdate;

@property(nonatomic, copy) NSString *chongzhiDou;

@end
