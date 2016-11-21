//
//  SendCircleMessegeController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SendCircleMessegeController.h"
#import "SendMsgToolBar.h"
#import "ZLPhotoAssets.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoPickerBrowserViewController.h"
@interface SendCircleMessegeController ()<SendMsgToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate>

@property(nonatomic,strong)UIButton * rightBtn;
/**
 *  imageView数组
 */
@property(nonatomic,strong)NSMutableArray * imageViewArray;
/**
 *  Asset数组
 */
@property(nonatomic,strong)NSMutableArray * imageArray;

@property(nonatomic,strong)SendMsgToolBar * toolBar;


@end

@implementation SendCircleMessegeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    self.imageViewArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    NSArray *navBtns = [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:nil andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightClick) withRightBtnTitle:@"发布"];
    self.rightBtn = navBtns[1];
    self.rightBtn.width = 45;
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"5eb5ff"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self createUI];
    
    
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
    
    [self.textView.textView resignFirstResponder];
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];

    NSString *url = self.interfaceManager.createCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community/create" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    param[@"communityType"] = self.communityType;

    param[@"content"] = self.textView.textView.text;
    param[@"anonymous"] =@(self.toolBar.nimingSwitch.isOn);

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            if (self.imageArray.count>0) {//有图片

                int idNum = [dict[@"info"][@"communityInfo"][@"id"] intValue];
                
                [self uploadPictureWithCircleID:idNum];
                
            }else
            {
            
                [self.hudManager showSuccessSVHudWithTitle:@"发布成功!" hideAfterDelay:1.0 animaton:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NOTIFICATION_CENTER postNotificationName:kUpdateCircleNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }

        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0f];
    }];



}
-(void)uploadPictureWithCircleID:(int)idNum
{
    __block int count = 0;
    for (int i = 0; i<self.imageArray.count; i++) {
        
        NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
        paramDic[@"uid"] = kUid;
        NSString * timeStr = [HttpParamManager getTime];
        paramDic[@"time"] = timeStr;
        paramDic[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community/submitPics" time:timeStr];
        paramDic[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
        paramDic[@"cityId"] = @([HttpParamManager getCurrentCityID]);
        paramDic[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
        paramDic[@"id"] = @(idNum);
        paramDic[@"communityType"] = self.communityType;

        ZLPhotoAssets *assets = self.imageArray[i];
        
        UIImage *image = assets.originImage;
        //UIImage转换为NSData
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        [HJHttpManager UploadFileWithUrl:self.interfaceManager.communitySubmitPics param:paramDic serviceName:@"pic" fileName:@"0.png" mimeType:@"image/jpeg" fileData:imageData finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"+++++%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                
                count++;
                
                if (count == self.imageArray.count) {
                    
                    [self.hudManager showSuccessSVHudWithTitle:@"发布成功" hideAfterDelay:1.0 animaton:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [NOTIFICATION_CENTER postNotificationName:kUpdateCircleNotification object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
            }else {
                
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
                
                return;
            }
            
            
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"上传失败" hideAfterDelay:1.0f];
            
            return;
            
        }];
    }
    

}
-(void)createUI
{
    
    self.textView = [[[NSBundle mainBundle] loadNibNamed:@"HClTextView" owner:nil options:nil]lastObject];
    [self.textView setPlaceholder:@"有什么想说的" contentText:nil maxTextCount:500];
    self.textView.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.delegate = self;
    self.textView.textView.backgroundColor = [UIColor whiteColor];
    self.textView.clearButtonType = ClearButtonAppearWhenEditing;
    self.textView.frame = CGRectMake(0, 0, kScreenWidth, 310);
    [self.view addSubview:self.textView];

    SendMsgToolBar *sendToolBar = [[[NSBundle mainBundle] loadNibNamed:@"SendMsgToolBar" owner:nil options:nil]lastObject];
    self.toolBar = sendToolBar;
    sendToolBar.delegate = self;
    sendToolBar.frame = CGRectMake(0, 310-64, kScreenWidth, 40);
    [self.view addSubview:sendToolBar];
    
    HJLog(@"%f",self.textView.innerTextViewBottomConstriant.constant);
    
}
-(void)sendMsgToolBar:(SendMsgToolBar *)toolBar didClickButtonType:(SendMsgToolBarButtonType)type
{
    switch (type) {
        case SendMsgToolBarCameraBtn:
        {
            //拍照
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        
        
        }
            break;
        case SendMsgToolBarPhotoBtn:
        {
            //相册
            ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
            pickerVc.maxCount = 4;
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.photoStatus = PickerPhotoStatusPhotos;
            pickerVc.topShowPhotoPicker = YES;
            pickerVc.isShowCamera = NO;
            pickerVc.selectPickers = self.imageArray;
            // CallBack
            pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
                
                self.imageArray = status.mutableCopy;
                
                [self reloadImageSubviewLayout];
                
                
            };
            [pickerVc showPickerVc:self];
            
        }
            break;
        case SendMsgToolBarNimingBtn:
        {
            
           
            
            
        }
            break;
            
        default:
            break;
    }



}
-(void)reloadImageSubviewLayout
{
    
    [self.imageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.imageArray.count > 0) {
        
        CGFloat margin = 10;
        CGFloat imageW =(kScreenWidth-5*margin)/4;
        
        self.textView.innerTextViewBottomConstriant.constant =5+imageW+30;
        
        for (int i = 0; i<self.imageArray.count; i++) {
            
            ZLPhotoAssets *asset = self.imageArray[i];
            
            UIImageView *imageView =[[UIImageView alloc]init];
            
            imageView.image = asset.originImage;
            
            imageView.frame = CGRectMake(margin+(margin+imageW)*i, 310-imageW-64-40, imageW, imageW);
            imageView.tag = 1999+i;
            imageView.userInteractionEnabled = YES;
            
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer * sender) {
                
                UIImageView *imageView = (UIImageView *)sender.view;
                // 图片游览器
                ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
                // 淡入淡出效果
                pickerBrowser.status = UIViewAnimationAnimationStatusFade;
                // 数据源/delegate
                pickerBrowser.editing = YES;
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i<self.imageArray.count; i++) {
                    ZLPhotoAssets *ass = self.imageArray[i];
                    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:ass.originImage];
                    [arr addObject:photo];
                }
                
                pickerBrowser.photos = arr;
                // 能够删除
                pickerBrowser.delegate = self;
                // 当前选中的值
                pickerBrowser.currentIndex = imageView.tag-1999;
                // 展示控制器
                [pickerBrowser showPickerVc:self];
                
                
            }]];
            
            [self.view addSubview:imageView];
            
            [self.imageViewArray addObject:imageView];
            
        }
        
    }
    else
    {
        self.textView.innerTextViewBottomConstriant.constant = 5;
        
    }


}
/**
 *  删除indexPath对应索引的图片
 *
 *  @param indexPath        要删除的索引值
 */
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
 
    UIImageView *deleteImageView = self.imageViewArray[index];
    
    [deleteImageView removeFromSuperview];
    
    [self.imageViewArray removeObjectAtIndex:index];
    
    [self.imageArray removeObjectAtIndex:index];
    
    [self reloadImageSubviewLayout];



}
/**
 *  UIImagePickerControllerDelegate
 *
 *  @param picker picker
 *  @param info   选取的图片信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    ZLPhotoAssets *asset = [ZLPhotoAssets assetWithImage:image];
    
    [self.imageArray addObject:asset];
    
    [self reloadImageSubviewLayout];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
