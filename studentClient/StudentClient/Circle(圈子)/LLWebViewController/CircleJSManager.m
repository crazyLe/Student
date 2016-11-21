//
//  CircleJSManager.m
//  Coach
//
//  Created by LL on 16/8/22.
//  Copyright © 2016年 sskz. All rights reserved.
//
#import "ShareView.h"
#import "CircleDetailWebController.h"
#import <IQKeyboardManager.h>
#import "ChatBarContainer.h"
#import "CircleJSManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
@interface CircleJSManager ()

@property (nonatomic,strong)ShareView *shareView;

@property (nonatomic,strong)UIView *cover;

@end
@implementation CircleJSManager
{
    ChatBarContainer *_chat_Bar;
}

- (id)init
{
    if (self = [super init]) {
        WeakObj(self)
        self.block = ^(UIViewController *webViewController){
            [selfWeak.bridge registerHandler:@"objcHander" handler:^(id data, WVJBResponseCallback responseCallback) {
                NSLog(@"ObjC Echo called with: %@", data);
                responseCallback(data);
                NSDictionary *paraDic = data;
                NSArray *keyArr = paraDic.allKeys;
                if (keyArr.count>0) {
                    NSString *para = paraDic[keyArr[0]];
                    NSArray *paraArr = [para componentsSeparatedByString:@":"];
                    if (paraArr.count>0) {
                        NSString *typeStr = paraArr[0];
                        if ([typeStr isEqualToString:@"comment"]) {
                            //点击Web评论按钮
                            if (paraArr.count>1) {
                                NSString *circleId = [paraArr lastObject];
                                [selfWeak clickCommentWithCircleId:circleId webViewVC:(CircleDetailWebController *)webViewController];
                            }
                        }
                        else if([typeStr isEqualToString:@"like"])
                        {
                            //点击了点赞
                            NSString *circleId = [paraArr lastObject];
                            [selfWeak clickLikeWithCircleId:circleId webViewVC:(CircleDetailWebController *)webViewController];
                        }
                        else if ([typeStr isEqualToString:@"Share"])
                        {
                            //分享
                            //点击了Web分享按钮
                            if (paraArr.count>1) {
                                NSString *shareUrl = [paraArr lastObject];
                                [selfWeak shareWithUrl:shareUrl webVC:webViewController];
                            }
                        }
                        else
                        {
                            
                        }
                    }
                }
            }];
        };
    }
    return self;
}

//点击评论
- (void)clickCommentWithCircleId:(NSString *)circleId webViewVC:(CircleDetailWebController *)webVC
{
    if (kLoginStatus) {
        [self setComment_TextFieldWithVC:webVC];
        _chat_Bar.userInfo = @{@"circleId":circleId};
    }
    else
    {
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [webVC presentViewController:loginnavC animated:YES completion:nil];
        
    }
    
}

//点击赞
- (void)clickLikeWithCircleId:(NSString *)circleId webViewVC:(CircleDetailWebController *)webVC
{
    if (kLoginStatus) {
        WeakObj(self)
        
        NSString *relativeAdd = @"/community/praise";
        
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        NSString * url = [NSString stringWithFormat:@"%@%@",TESTBASICURL,relativeAdd];
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"uid"] = kUid;
        NSString * time = [HttpParamManager getTime];
        paramDict[@"time"] = time;
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:relativeAdd time:time];
        paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
        paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
        paramDict[@"id"] =circleId;
        paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@">>>%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                
                [self.hudManager dismissSVHud];
                [webVC.webView reload];
                if (_needRefreshBlock) {
                    _needRefreshBlock(selfWeak);
                    
                }
                
            }
            else
            {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                
            }
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        }];
        

    }
    else
    {
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [webVC presentViewController:loginnavC animated:YES completion:nil];
        
    }
   
}

- (void)setComment_TextFieldWithVC:(CircleDetailWebController *)webVC
{
    if (!_chat_Bar) {
        _chat_Bar = [[ChatBarContainer alloc]init];
        _chat_Bar.max_Count = 140;
        _chat_Bar.myDelegate = self;
        [webVC.view addSubview:_chat_Bar];
        [_chat_Bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(webVC.view.mas_left);
            make.right.equalTo(webVC.view.mas_right);
            make.bottom.equalTo(webVC.view.mas_bottom);
            make.height.offset(44);
        }];
        [_chat_Bar setNeedsLayout];
        [_chat_Bar.layer layoutIfNeeded];
        _chat_Bar.object = webVC;
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = NO;
        
        webVC.webView.scrollView.delegate = self;
    }
    
    [_chat_Bar.txtView becomeFirstResponder];
}

#pragma mark - ChatBarContainerDelegate

//点击评论发送按钮
- (void)ChatBarContainer:(ChatBarContainer *)chatBar clickSendWithContent:(NSString*)content;
{
    
    WeakObj(self)
    
    CircleDetailWebController *webVC = chatBar.object;
    
    NSString *circelId = chatBar.userInfo[@"circleId"];
    
    NSString *relativeAdd = @"/community/commentcreate";
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = [NSString stringWithFormat:@"%@%@",TESTBASICURL,relativeAdd];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:relativeAdd time:time];
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    paramDict[@"id"] =circelId;
    paramDict[@"communityType"] =webVC.object;
    paramDict[@"content"] =chatBar.txtView.text;
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            //成功
            //刷新页面

            [webVC.webView reload];
            
            if (_needRefreshBlock) {
                _needRefreshBlock(selfWeak);
            }
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];


    chatBar.alpha = 0;
    [chatBar.txtView resignFirstResponder];
}

- (void)chatBarDidBecomeActive;
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [_chat_Bar.txtView resignFirstResponder];
}

/****************分享相关************/

- (ShareView *)shareView
{
    if (!_shareView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
        self.shareView.delegate = self;
        self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _cover.backgroundColor = [UIColor darkGrayColor];
        _cover.userInteractionEnabled = YES;
        _cover.alpha = 0.0f;
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translucentCoverViewSingleTap:)];
        [_cover addGestureRecognizer:singleTapGesture];
        //    [self.view addSubview:_cover];
        [window addSubview:_cover];
    }
    return _shareView;
}

- (void)shareWithUrl:(NSString *)url webVC:(UIViewController *)webViewVC
{
    NSLog(@"====>share url %@",url);
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    
    if (isEmptyStr(url)) {
        NSLog(@"share url is a empty string , please check!");
        return;
    }
    
    //    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
    //
    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"下载康庄教练端有惊喜哦" image:[UIImage imageNamed:@"组-1"] location:nil urlResource:resource presentedController:nil completion:^(UMSocialResponseEntity *response){
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //            [LLUtils showSuccessHudWithStatus:@"分享成功!"];
    //        }
    //        else{
    //            NSLog(@"分享失败! ");
    //            [LLUtils showSuccessHudWithStatus:@"分享失败!"];
    //        }
    //    }];
    
    //    [UMSocialSnsService presentSnsIconSheetView:_vc
    //                                         appKey:kUMENG_APP_KEY
    //                                      shareText:@"这是一个分享测试"
    //                                     shareImage:[UIImage imageNamed:@"icon.png"]
    //                                shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ]
    //                                       delegate:self];
    
    self.shareView.object = webViewVC;
    self.cover.alpha = 0.8;
    [self.shareView show];
}

-(void)translucentCoverViewSingleTap:(UITapGestureRecognizer *)tap
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];
    
}
-(void)shareViewDidClickCancelButton:(ShareView *)shareView
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];
    
}
-(void)shareView:(ShareView *)shareView didClickButtonWithType:(ShareViewBtnType)type
{
    shareView.transform = CGAffineTransformIdentity;
    [shareView removeFromSuperview];
    self.cover.alpha = .0f;
    
    NSString *shareType = nil;
    
    switch (type) {
        case ShareViewBtnWeChatQuan:
        {
            
            shareType = UMShareToWechatTimeline;
            
        }
            break;
        case ShareViewBtnWeChat:
        {
            //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
            
            
            //            [UMSocialSnsService presentSnsIconSheetView:self
            //                                                 appKey:kUMENG_APP_KEY
            //                                              shareText:@"这是一个分享测试"
            //                                             shareImage:[UIImage imageNamed:@"icon.png"]
            //                                        shareToSnsNames:@[UMShareToWechatSession]
            //                                               delegate:self];
            shareType = UMShareToWechatSession;
        }
            break;
        case ShareViewBtnWeBo:
        {
            shareType = UMShareToQQ;
        }
            break;
        case ShareViewBtnQQZone:
        {
            
            shareType = UMShareToQzone;
        }
            break;
            
        default:
            break;
    }
    
    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:@"www.sskz.com.cn"];
    
    UIViewController *webVC = shareView.object;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"下载康庄学车有惊喜哦" image:[UIImage imageNamed:@"图标"] location:nil urlResource:resource presentedController:webVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [self.hudManager showSuccessSVHudWithTitle:@"分享成功" hideAfterDelay:1.0 animaton:YES];
        }
        else{
            NSLog(@"分享失败! ");
        }
    }];
    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
