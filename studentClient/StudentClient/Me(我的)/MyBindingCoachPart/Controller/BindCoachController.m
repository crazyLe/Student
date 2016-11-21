//
//  BindCoachController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BindCoachController.h"
#import "KZSearchBar.h"
#import "BindCoachCell.h"
#import "CLAlertView.h"
#import "CoachModel.h"
#import <UIViewController+JTNavigationExtension.h>
@interface BindCoachController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BindCoachCellDelegate>
{
    int curpage;
}
@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,weak)KZSearchBar *search;

//教练集合
@property(nonatomic,strong)NSMutableArray *coachArr;

//绑定成功教练
@property(nonatomic,strong)CoachModel *bdCoach;

@end

@implementation BindCoachController

- (NSMutableArray *)coachArr{
    if (!_coachArr) {
        _coachArr = [NSMutableArray array];
    }
    return _coachArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"绑定教练"];
    
    [self createUI];
    
    if (_sub == nil) {
        _sub = @"second";
    }
    curpage = 1;
    [self loadData:@"" andSubjects:_sub andPage:curpage];
    
}
/**
 *  查询教练接口
 *
 *  @param str 检索内容
 *  @param sub second(科目二) thred(科目三)
 */
- (void)loadData:(NSString *)str andSubjects:(NSString *)sub andPage:(int)page
{
    NSString *postUrl =  self.interfaceManager.mineCoach;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    NSLog(@"%@",kUid);
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/mineCoach" time:time];
    
    param[@"serach"] = str;
    param[@"subjects"] = sub;
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"pageId"] = [NSString stringWithFormat:@"%d",page];
    NSLog(@"%@",param);
    [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@== %@",dict,dict[@"msg"]);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary *infoDict = dict[@"info"];
            
            NSLog(@"infoDict== %@",infoDict);
            
             NSArray *coachs = infoDict[@"coachs"];
            
            if (page != 1) {
                for (int i =0; i<coachs.count; i++) {
                    CoachModel *model = [CoachModel mj_objectWithKeyValues:coachs[i]];
                    [self.coachArr addObject:model];
                }
            }else
            {
                self.coachArr = [CoachModel mj_objectArrayWithKeyValuesArray:coachs];
                NSLog(@"self.coachArr== %d",(int)self.coachArr.count);
            }
            
            [self.collectionView reloadData];
            [self.hudManager dismissSVHud];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

/**
 *  绑定教练
 *
 *  @param coacdID 教练ID
 *  @param sub     科目类别
 */
- (void)bdCoach:(NSString *)coacdID andSubject:(NSString *)sub model:(CoachModel *)model
{
    NSString *postUrl =  self.interfaceManager.bindingCoach;
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    NSLog(@"%@",kUid);
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/bindingCoach" time:time];
    param[@"coachId"] = coacdID;
    param[@"subjects"] = sub;
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    NSLog(@"%@",param);
    [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@== %@",dict,dict[@"msg"]);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            CLAlertView * alertView = [[CLAlertView alloc] initWithAlertViewWithTitle:@"操作成功" text:msg DefauleBtn:nil cancelBtn:@"朕知道了" defaultBtnBlock:^(UIButton *defaultBtn) {
                
                
            } cancelBtnBlock:^(UIButton *cancelBtn){
                
                [NOTIFICATION_CENTER postNotificationName:kRefreshMyCoachStateNotification object:nil];

                model.bind_status = @"0";
                
                [self.collectionView reloadData];

            }];
            
            [alertView show];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
}
- (void)createUI {
    
    //创建自定义搜索框
    KZSearchBar * searchBar = [KZSearchBar searchBar];
    searchBar.frame = CGRectMake(0, 0, kScreenWidth - 80, 49);
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.textColor = [UIColor colorWithHexString:@"#666666"];
    searchBar.font = [UIFont systemFontOfSize:autoScaleFont(15)];
    searchBar.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"输入您要绑定教练的姓名或手机号码"] ;
    self.search = searchBar;
    [self.view addSubview:searchBar];
    
    //创建右侧搜索按钮
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(kScreenWidth - 80, 0, 80, 49);
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#b9c4c9"];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"a3adb5"]] forState:UIControlStateHighlighted];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    //创建主体的collectionView(包括区头视图)
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(11, 11, 11, 11);
    layout.minimumLineSpacing = 11;
    layout.minimumInteritemSpacing = 11;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, kScreenHeight - kNavHeight - 49) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"BindCoachCell" bundle:nil] forCellWithReuseIdentifier:@"BindCoachCell"];
    
    //上下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        curpage = 1;
        [self loadData:@"" andSubjects:_sub andPage:1];
        [_collectionView.mj_header endRefreshing];
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        curpage++;
        [self loadData:@"" andSubjects:_sub andPage:curpage];
        [_collectionView.mj_footer endRefreshing ];
    }];
}
#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.coachArr.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    static NSString * identifier = @"BindCoachCell";
    BindCoachCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    CoachModel *model = [self.coachArr objectAtIndex:row];
    cell.coach = model;
    cell.delegate = self;
    return cell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //image是正方形,此时高度要自适应
    CGSize size = CGSizeMake((kScreenWidth - 33)/2, (kScreenWidth -33)/2 +65);
    
    return size;
}
-(void)bindCoachCellDidClickBindBtn:(BindCoachCell *)cell
{
    NSLog(@"%@",cell);
    _bdCoach = cell.coach;
    [self bdCoach:cell.coach.coachId andSubject:_sub model:_bdCoach];
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBtnClick {
    
}
- (void)searchBtnClick:(UIButton *)btn
{
    NSString *str = self.search.text;
    if (str.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入检索内容" hideAfterDelay:1.0];
        return;
    }
    [self loadData:str andSubjects:_sub andPage:1];
    
    self.search.text = nil;
    
}

- (void)leftBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    curpage = 1;
}

@end
