//
//  FindDriverSchoolVC.m
//  学员端
//
//  Created by gaobin on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "FindDriverSchoolVC.h"
#import "FindDriverSchoolCell.h"
#import "DriveSchoolModel.h"
#import "DriverSchoolWebVC.h"
#import "FindDrivingSectionHeader.h"
#import "KZCustomSearchBar.h"

static NSString *const kFindDrivingSectionHeader = @"FindDrivingSectionHeader";

static CGFloat const kScrollAlphaChangeHeight = 240;

@interface FindDriverSchoolVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) KZCustomSearchBar *searchBar;
@property (nonatomic, strong) UIView *titleSearchView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) BOOL isMinDistance;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) int  classType;
@property (nonatomic, assign) int  currentPage;

@end

@implementation FindDriverSchoolVC
#pragma mark --lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentPage = 1;
    
    _dataArray = [NSMutableArray array];

    self.view.backgroundColor = BG_COLOR;
    
    [self createNavigation];
    
    [self createUI];
    
    _isRecommend = YES;

    _isMinDistance = NO;
    
    _classType = 1;//默认C1
}

- (void)createNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    //设置y值从屏幕最上方开始
    self.edgesForExtendedLayout = UIRectEdgeTop;
    //开启导航栏透明。使得y值从最上方开始
    [self.navigationController.navigationBar setTranslucent:YES];

    //设置导航栏渲染色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = self.titleSearchView;
}

- (void)requestData {
    NSString * url = self.interfaceManager.searchSchools;
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Search/SearchSchools"time:time];
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    //提给给后台一个距离最近的数据(改为必填)修改推荐
    paramDict[@"distanceFirst"] = @(0);

    if (_isRecommend) {
        paramDict[@"recommended"] = @(1);
    }
    if (_isMinDistance) {
        paramDict[@"distanceFirst"] = @(1);
    }
    paramDict[@"classType"] = @(_classType);
    
    if (_isSearch ) {
        paramDict[@"serach"] = _searchBar.text;
    }
    paramDict[@"pageId"] = @(self.currentPage);
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        NSDictionary *dataInfo = dict[@"info"];

        if (code == 1) {
            
            NSArray *array = dataInfo[@"schools"];
            
            _dataArray = [DriveSchoolModel mj_objectArrayWithKeyValuesArray:array];
            
            [_collectionView reloadData];
        
            [self.collectionView.mj_header endRefreshing];
            
            [self.hudManager dismissSVHud];
        } else {
            _dataArray = [NSMutableArray array];
            [_collectionView reloadData];
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [self.collectionView.mj_header endRefreshing];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败,请重试" hideAfterDelay:1.0f];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)requestMoreData {
    NSString * url = self.interfaceManager.searchSchools;
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Search/SearchSchools"time:time];
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    //提给给后台一个距离最近的数据(改为必填)
    paramDict[@"distanceFirst"] = @(0);

    if (_isRecommend) {
        paramDict[@"recommended"] = @(1);
    }
    if (_isMinDistance) {
        paramDict[@"distanceFirst"] = @(1);
    }
    paramDict[@"classType"] = @(_classType);
        
    if (_isSearch ) {
        paramDict[@"serach"] = _searchBar.text;
    }
    paramDict[@"pageId"] = @(self.currentPage);
    
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        
        if (code == 1) {
            NSArray * array = dict[@"info"][@"schools"];
            NSArray *temp = [DriveSchoolModel mj_objectArrayWithKeyValuesArray:array];
            
            [self.dataArray addObjectsFromArray:temp];
            
            [_collectionView reloadData];
            
            [self.collectionView.mj_footer endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [self.collectionView.mj_footer endRefreshing];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败,请重试" hideAfterDelay:1.0f];
        [self.collectionView.mj_footer endRefreshing];
    }];
}


- (void)createUI {

    //创建主体的collectionView(包括区头视图)
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 11, 11, 11);
    layout.minimumLineSpacing = 11;
    layout.minimumInteritemSpacing = 11;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"FindDriverSchoolCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FindDriverSchoolCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FindDrivingSectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFindDrivingSectionHeader];
    
    __weak typeof(self) weakSelf = self;
    //上下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf requestData];
    }];
    
    [_collectionView.mj_header beginRefreshing];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        
        [weakSelf requestMoreData];
        
    }];
    
    self.collectionView.mj_footer.automaticallyHidden = YES;
}

#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"FindDriverSchoolCell";
    FindDriverSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //加阴影
    cell.driveSchoolModel = self.dataArray[indexPath.row];
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 5.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.05f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    DriveSchoolModel * driveSchool = _dataArray[indexPath.row];
    [cell.driverSchoolImgView sd_setImageWithURL:[NSURL URLWithString:driveSchool.imgUrl] placeholderImage:[UIImage imageNamed:@"drivingSchoolAvatar"]];
    cell.nameLab.text = driveSchool.schoolName;
    if (driveSchool.installment) {
        cell.supportStageLab.text = @"支持分期";
        cell.supportStageLab.textAlignment = NSTextAlignmentCenter;
        cell.supportStageLab.layer.cornerRadius = 3;
        cell.supportStageLab.clipsToBounds = YES;
    } else {
        cell.supportStageLab.hidden = YES;
    }
    if (driveSchool.preferential) {
        cell.discountImgView.image = [UIImage imageNamed:@"惠"];
    } else {
        cell.discountImgView.hidden = YES;
    }
    cell.numberEnrollLab.text = [NSString stringWithFormat:@"%d个报名网点",driveSchool.reports];
    cell.distanceLab.text = [NSString stringWithFormat:@"%dkm",driveSchool.distance];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //image是正方形,此时高度要自适应
    CGSize size = CGSizeMake((kScreenWidth - 33)/2, (kScreenWidth -69)/2 +45);

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DriveSchoolModel *model = self.dataArray[indexPath.row];
    
    DriverSchoolWebVC *VC = [[DriverSchoolWebVC alloc]init];
    
    VC.driverSchool = model;
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 返回collectionView区头视图的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kScreenWidth * 433 / 853);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    FindDrivingSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFindDrivingSectionHeader forIndexPath:indexPath];

    return sectionHeader;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        return;
    }

    _isSearch = YES;

    [self requestData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
    }
}

#pragma mark -- 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        float alpha = self.collectionView.contentOffset.y / kScrollAlphaChangeHeight;

        if (alpha > 1.0) {
            alpha = 1.0;
        }

        UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"353c3f" alpha:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark -- setters and getters
- (UIView *)titleSearchView {
    if (!_titleSearchView) {
        _titleSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 36)];//allocate titleView

        _titleSearchView.backgroundColor = [UIColor clearColor];

        KZCustomSearchBar *searchBar = [[KZCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 35)];
        searchBar.placeholder = @"输入名称或班型寻找适合您的驾校";
        searchBar.delegate = self;
        self.searchBar = searchBar;
        [_titleSearchView addSubview:searchBar];
    }
    return _titleSearchView;
}

@end
