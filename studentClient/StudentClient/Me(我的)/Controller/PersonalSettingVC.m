//
//  PersonalSettingVC.m
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonalSettingVC.h"
#import "PersonalInformationCell.h"
#import "HeaderImageCell.h"
#import "IntroduceMyselfCell.h"
#import "ZHPickView.h"
#import "OSAddressPickerView.h"
#import "ProvinceModel.h"
#import "AppDelegate.h"
@interface PersonalSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ZHPickViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertView *nickNameAlert;
@property (nonatomic, strong) UITextField *nickNameTF;
@property (nonatomic, strong) ZHPickView *agePickView;
@property (nonatomic, strong) ZHPickView *sexPickView;
@property (nonatomic, assign) NSInteger lastSelectCell;
@property (nonatomic, strong) OSAddressPickerView *pickerview;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIImage *selectImage;



@end

@implementation PersonalSettingVC
#pragma mark -- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"个人设置" andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick) withRightBtnTitle:@"保存" rightColor:[UIColor colorWithHexString:@"#5fb6ff"]];

    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_agePickView remove];
    [_sexPickView remove];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [NOTIFICATION_CENTER postNotificationName:kRefreshPersonInfoNotification object:nil];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#ececec"];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PersonalInformationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalInformationCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HeaderImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HeaderImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"IntroduceMyselfCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IntroduceMyselfCell"];
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 1) {
            
            static NSString * identifier = @"HeaderImageCell";
            HeaderImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.titleLab.text = @"头像";
            if (self.selectImage) {
                cell.headerImgView.image = self.selectImage;
            } else {
                [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:_personalInfo.face] placeholderImage:[UIImage imageNamed:@"iconfont-touxiang(1)"]];
            }
            return cell;
            
        } else {
            
            static NSString * identifier = @"PersonalInformationCell";
            PersonalInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.detailLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLab.text = @"昵称";
                    cell.detailLab.text = _personalInfo.nickName;
                    break;
                }
                case 2:
                {
                    NSArray * provinceArr = kProvinceDict;
                    NSString * provinceStr = @"";
                    for (NSDictionary * dic in provinceArr) {
                        if ([dic[@"id"] isEqualToString:_personalInfo.provinceId]) {
                            provinceStr = dic[@"title"];
                        }
                    }
                    NSArray *cityArr = kCityDict;
                    NSString * cityStr = @"";
                    for (NSDictionary *dic in cityArr) {
                        if ([dic[@"id"] isEqualToString:_personalInfo.cityId]) {
                            cityStr = dic[@"title"];
                        }
                    }
                    NSArray * countryArr = kCountryDict;
                    NSString * countryStr = @"";
                    for (NSDictionary * dict in countryArr) {
                        if ([dict[@"id"] isEqualToString:_personalInfo.areaId]) {
                            countryStr = dict[@"title"];
                        }
                    }
                    
                    cell.titleLab.text = @"地址";
                    cell.detailLab.text = [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,countryStr];
                    break;
                }
                case 3:
                {
                    cell.titleLab.text = @"手机号";
                    cell.detailLab.text = _personalInfo.phone;
                    break;
                }
                case 4:
                {
                    cell.titleLab.text = @"年龄";
                    cell.detailLab.text = _personalInfo.age;
                    break;
                }
                case 5:
                {
                    cell.titleLab.text = @"性别";
                    if ([_personalInfo.sex isEqualToString:@"0"]) {
                        
                        cell.detailLab.text = @"女";
                    }else {
                        cell.detailLab.text = @"男";
                    }
                   
                    break;
                }
                default:
                    break;
            }

            return cell;
        }
    } else {
        static NSString * identifier = @"IntroduceMyselfCell";
        IntroduceMyselfCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.personalInfo = _personalInfo;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else {
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return CGFLOAT_MIN;
    }
}

//让分割线的左边到头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_agePickView remove];
    [_sexPickView remove];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //修改昵称
            _nickNameAlert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_nickNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            _nickNameAlert.tag = 1000;
            
            [_nickNameAlert show];
            
        }
        if (indexPath.row == 1) {
            //修改头像
           // _lastSelectCell = indexPath.row;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
            [actionSheet showInView:self.view];
            
            
        }
        if (indexPath.row == 2) {
            //修改地址
            _pickerview = [OSAddressPickerView shareInstance];
            
            NSArray *addressArr = kAddressData;
            
            NSMutableArray *dataArray = [NSMutableArray  array];
            
            for (NSData *data in addressArr) {
                ProvinceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [dataArray addObject:model];
            }
            _pickerview.dataArray = dataArray;
            
            [_pickerview showBottomView];
            
            [self.view addSubview:_pickerview];
            
            WeakObj(self);

            _pickerview.block = ^(ProvinceModel *provinceModel,CityModel *cityModel,CountryModel *districtModel)
            {
                
                selfWeak.personalInfo.provinceId = [NSString stringWithFormat:@"%d",provinceModel.idNum];
                
                selfWeak.personalInfo.cityId = [NSString stringWithFormat:@"%d",cityModel.idNum];
                
                selfWeak.personalInfo.areaId = [NSString stringWithFormat:@"%d",districtModel.idNum];
                
                [selfWeak.tableView reloadData];

            };
        }
        if (indexPath.row == 3) {
            //修改手机号
            UIAlertView * phoneAlert = [[UIAlertView alloc] initWithTitle:@"修改手机号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            phoneAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            phoneAlert.tag = 3000;
            _phoneTF = [phoneAlert textFieldAtIndex:0];
            _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
            [phoneAlert show];
        }
        if (indexPath.row == 4) {
            //修改年龄
            NSMutableArray * ageArray = [NSMutableArray array];
            for (int i = 0; i < 101; i++) {
                [ageArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            _agePickView = [[ZHPickView alloc] initPickviewWithArray:ageArray isHaveNavControler:NO];
            _agePickView.tag = 400;
            _agePickView.delegate = self;
            [_agePickView setPickViewColer:[UIColor whiteColor]];
            [_agePickView show];
        }
        if (indexPath.row == 5) {
            //修改性别
            NSArray * sexArray = [NSArray arrayWithObjects:@"男",@"女", nil];
            _sexPickView = [[ZHPickView alloc] initPickviewWithArray:sexArray isHaveNavControler:NO];
            _sexPickView.tag = 500;
            _sexPickView.delegate = self;
            [_sexPickView setPickViewColer:[UIColor whiteColor]];
            [_sexPickView show];
        }
    }
}

#pragma mark --  ZHPickView的代理方法
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    
    if (pickView.tag == 400) {
        _personalInfo.age = resultString;
        
        [_tableView reloadData];
    }
    if (pickView.tag == 500) {
        
        if ([resultString isEqualToString:@"女"]) {
            _personalInfo.sex = @"0";
        }else {
            _personalInfo.sex = @"1";
        }
        [_tableView reloadData];
            
    }
}
#pragma mark -- alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            _nickNameTF = [alertView textFieldAtIndex:0];
            _personalInfo.nickName = _nickNameTF.text;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }
    }

    if (alertView.tag == 3000) {
        if (buttonIndex == 1) {

            _phoneTF = [alertView textFieldAtIndex:0];
            
            if (_phoneTF.text.length == 0) {
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            
            NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            BOOL isMatch = [pred evaluateWithObject:_phoneTF.text];
            
            if (!isMatch) {
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
            } else {
                
                _personalInfo.phone = _phoneTF.text;
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                PersonalInformationCell * cell = (PersonalInformationCell *)[_tableView cellForRowAtIndexPath:indexPath];
                
                cell.detailLab.text = _personalInfo.phone;
            }
        }
    }
}

#pragma mark --actionSheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //从相册选取
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        //imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;时光
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    if (buttonIndex == 1) {
        //拍照
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];

    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self requestDataWithImage:image];
}

- (void)requestDataWithImage:(UIImage *)image {
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];

    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    paramDic[@"uid"] = kUid;
    NSString * timeStr = [HttpParamManager getTime];
    paramDic[@"time"] = timeStr;
    paramDic[@"sign"] = [HttpParamManager getSignWithIdentify:@"/userPics" time:timeStr];
    paramDic[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager UploadFileWithUrl:self.interfaceManager.userPics param:paramDic serviceName:@"pics" fileName:@"0.png" mimeType:@"image/jpeg" fileData:UIImageJPEGRepresentation(image, 0.5) finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            
            HeaderImageCell * cell = (HeaderImageCell *)[_tableView cellForRowAtIndexPath:indexPath];
            
            cell.headerImgView.image = image;
            
            self.selectImage = image;

            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"上传失败" hideAfterDelay:1.0f];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//提交个人设置
- (void)rightBtnClick {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"保存中..."];
    NSString * url = self.interfaceManager.submitPersonalInfo;
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    paramDic[@"uid"] = kUid;
    NSString * timeStr = [HttpParamManager getTime];
    paramDic[@"time"] = timeStr;
    paramDic[@"sign"] = [HttpParamManager getSignWithIdentify:@"/personalInformation" time:timeStr];
    paramDic[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    //修改的参数
    paramDic[@"nickName"] = _personalInfo.nickName;
    paramDic[@"trueName"] = _personalInfo.trueName;
    paramDic[@"provinceId"] = _personalInfo.provinceId;
    paramDic[@"cityId"] = _personalInfo.cityId;
    paramDic[@"areaId"] = _personalInfo.areaId;
    paramDic[@"address"] = _personalInfo.address;
    paramDic[@"age"] = _personalInfo.age;
    paramDic[@"sex"] = _personalInfo.sex;
    paramDic[@"introduce"] = _personalInfo.introduce;
    
    
    [HJHttpManager PostRequestWithUrl:url param:paramDic finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++___%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSIndexPath * index0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath * index2 = [NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath * index3 = [NSIndexPath indexPathForRow:3 inSection:0];
            NSIndexPath * index4 = [NSIndexPath indexPathForRow:4 inSection:0];
            NSIndexPath * index5 = [NSIndexPath indexPathForRow:5 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[index0,index2,index3,index4,index5,] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            
            [self.hudManager showSuccessSVHudWithTitle:@"保存成功" hideAfterDelay:1.0 animaton:YES];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [NOTIFICATION_CENTER postNotificationName:kRefreshPersonInfoNotification object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"保存失败" hideAfterDelay:1.0f];
    }];
}


@end
