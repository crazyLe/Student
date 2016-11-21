//
//  SubjectTwoExamHomeVC.m
//  学员端
//
//  Created by gaobin on 16/7/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectTwoExamHomeVC.h"
#import "LocationButton.h"
#import "SubTwoExamCell.h"
#import "HeaderReusableView.h"
#import "SubjectTwoExamDetailVC.h"
#import "ZHPickView.h"

@interface SubjectTwoExamHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HeaderReusableViewDelegate,ZHPickViewDelegate>

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) LocationButton * rightBtn;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * fromTimeBtn;
@property (nonatomic, strong) UIButton * toTimeBtn;
@property(nonatomic,strong)UIButton * carTypeBtn;
@property(nonatomic,assign)NSInteger startMin;
@property(nonatomic,assign)NSInteger toMin;
@property (nonatomic, strong) ZHPickView * fromPickerView;
@property (nonatomic, strong) ZHPickView * toPickerView;
@property (nonatomic, strong) ZHPickView * carTypePickView;


@end

@implementation SubjectTwoExamHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_COLOR;
    
    [self createNavigationBar];
    
    [self createUI];
    
    [self requestData];
    
    
    
}
- (void)requestData {
    
    NSString * url = self.interfaceManager.examAreaUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time =[HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/examinationRoomList"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"subject"] = @"second";
    paramDict[@"lng"] =  [HttpParamManager getLongitude];
    paramDict[@"lat"] = [HttpParamManager getLatitude];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_fromPickerView remove];
    [_toPickerView remove];
    [_carTypePickView remove];
}
- (void)createUI {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 12.5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"SubTwoExamCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubTwoExamCell"];
    [_collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
    
    
}
-(void)headerReusableView:(HeaderReusableView *)headerView didClickBtnWithType:(HeaderViewButtonType)type
{
    [_fromPickerView remove];
    [_toPickerView remove];
    [_carTypePickView remove];
    switch (type) {
        case HeaderButtonTypeFrom:
        {
            
            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0; i<24; i++) {
                [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSMutableArray *arr2 = [NSMutableArray array];
            for (int i = 0; i<60; i++) {
                [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 405;
            _fromPickerView = pickView;
            [pickView setPickViewColer:[UIColor whiteColor]];
            pickView.delegate = self;
            [pickView show];
            

        }
            break;
        case HeaderButtonTypeTo:
        {

            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0; i<24; i++) {
                [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSMutableArray *arr2 = [NSMutableArray array];
            for (int i = 0; i<60; i++) {
                [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 406;
            _toPickerView = pickView;
            [pickView setPickViewColer:[UIColor whiteColor]];
            pickView.delegate = self;
            [pickView show];
            
        }
            break;
        case HeaderButtonTypeCarType:
        {
            NSArray *arr = [NSArray arrayWithObjects:@"A1",@"A2",@"A3",@"B1",@"B2",@"C1",@"C2", nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 407;
            _carTypePickView = pickView;
            [pickView setPickViewColer:[UIColor whiteColor]];
            pickView.delegate = self;
            [pickView show];

            

            
        }
            break;
            
        default:
            break;
    }





}
#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 405) {
       
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
       
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger fromMin = hour *60 + min;
        if (fromMin>=_toMin&&_toMin!= 0) {
            [self.hudManager showErrorSVHudWithTitle:@"不能大于结束时间!" hideAfterDelay:1.0];
            return;
        }
        else
        {
            [self.fromTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
            self.startMin = hour *60 + min;
        }

    }
    if (pickView.tag == 406) {

        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger toMin = hour *60 + min;
        if (toMin<=_startMin) {
            [self.hudManager showErrorSVHudWithTitle:@"不能小于开始时间!" hideAfterDelay:1.0];
            return;
        }else
        {
            self.toMin = hour *60 + min;
            [self.toTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
        
        }
 
    }
    
    if (pickView.tag == 407) {
        
        [self.carTypeBtn setTitle:resultString forState:UIControlStateNormal];

    }
   

}
#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"SubTwoExamCell";
    SubTwoExamCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.examAreaImgView.image = [UIImage imageNamed:@"毛考考场图片"];
    cell.nameLab.text = @"合肥南岗考场";
    cell.nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.locationLab.text = @"地址:合肥市蜀山区临泉路与新蚌埠路交口";
    cell.locationLab.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.freeNumberLab.text = @"128";
    cell.freeNumberLab.textColor = [UIColor colorWithHexString:@"#5cb6ff"];
    cell.textLab.text = @"个空闲时段";
    cell.textLab.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.distanceImgView.image = [UIImage imageNamed:@"iconfont-juli"];
    cell.distanceLab.text = @"0.9km";
    cell.distanceLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    return cell;
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((kScreenWidth - 30)/2 , 240);
    
    return size;
    
}
#pragma mark -- 返回collectionView区头视图的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 80);
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HeaderReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
    headerView.delegate = self;
    self.fromTimeBtn = headerView.fromTimeBtn;
    self.toTimeBtn = headerView.toTimeBtn;
    self.carTypeBtn = headerView.carTypeBtn;
    return headerView;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SubjectTwoExamDetailVC *vc = [[SubjectTwoExamDetailVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];




}
- (void)createNavigationBar {
    
    NSArray * naviBtn = [self createRightLocationNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科二模考" andRightBtnImageName:@"iconfont-jiantou" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    
    _leftBtn = naviBtn[0];
    _rightBtn = naviBtn[1];

    [self.rightBtn setTitle:kCurrentLocationCity forState:UIControlStateNormal];

}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClick {
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
