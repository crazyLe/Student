//
//  SubjectThreeHomeVC.m
//  学员端
//
//  Created by gaobin on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectThreeHomeVC.h"
#import "CollectionViewCell.h"
#import "Masonry.h"
#import "IQKeyBoardManager.h"
#import "RealExaminationCell.h"
#import "MoviePlayerViewController.h"
#import "SubjectThreeVideoCell.h"
#import "SubjectVideoModel.h"
#import "SeekHelpCell.h"
#import "CLDropDownMenu.h"
#import "SubjectOneHomeVC.h"
#import "SubjectTwoHomeVC.h"
#import "ArticlesModel.h"
#import "SubjectFourHomeVC.h"
#import "SubjectDetailController.h"
#import "BaseWebController.h"
#import "PartnerTrainingVC.h"
@interface SubjectThreeHomeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SubjectThreeVideoCellDelegate,SeekHelpCellDelegate> {
    
    UITableView * _tableView;
    UICollectionView * _collectionView;
    UIPageControl * _pageControl;
    NSTimer * _timer;
}
@property(nonatomic,strong)NSMutableArray * videoArray;
@property(nonatomic,strong)NSMutableArray * articlesArray;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)NSMutableArray * quickEntrancesArray;
@property(nonatomic,strong)CLDropDownMenu * dropMenu;

@end

@implementation SubjectThreeHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.articlesArray = [NSMutableArray array];
    self.quickEntrancesArray = [NSMutableArray array];
    [self createNavigationBar];
    
    [self createTableView];
    
    [self loadData];
    
}
-(void)loadData
{
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    NSString *url = self.interfaceManager.subjectThird;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/subjectThird" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"subject"] = @"third";
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            NSArray *arr1 = dict[@"info"][@"articles"];
            self.articlesArray = [ArticlesModel mj_objectArrayWithKeyValuesArray:arr1];
            NSArray *arr2 = dict[@"info"][@"videos"];
            self.videoArray = [SubjectVideoModel mj_objectArrayWithKeyValuesArray:arr2];
            self.quickEntrancesArray = dict[@"info"][@"quickEntrances"];

            [_tableView reloadData];
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
- (void)addNSTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //把定时器添加到runloop中，告诉系统在处理其他事情的时候分一部分空间给它
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
-(void)removeNSTimer {
    
    [_timer invalidate];
    _timer=nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNSTimer];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addNSTimer];
    
}
- (void)nextPage {
    
    
    //取得当前页码
    NSInteger page = _pageControl.currentPage;
    //判断当前页码，如果是循环到最后一张后，设置当前页数为第一张
    if (page == _pageControl.numberOfPages - 1) {
        
        page = 0;
        
    }
    else
    {
        //否则继续＋＋
        page++;
        
    }
    
    //添加一个动画效果，让图片偏移不致于很突兀
    
    CGFloat offsetX = page * _collectionView.frame.size.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _collectionView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
        //如果图片转了一半以上，那么就把页数＋1
        int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
        //把page赋给当前页
        _pageControl.currentPage = page;
        
    }
}
//当用户开始拖拽的时候调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeNSTimer];
}
//当用户停止拖拽的时候调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self addNSTimer];
}

-(NSMutableArray *)videoArray
{
    if (!_videoArray) {
        
        _videoArray = [NSMutableArray array];
        
        
    }
    
    return _videoArray;
    
}




- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight ) style:UITableViewStyleGrouped];
    [_tableView registerClass:[RealExaminationCell class] forCellReuseIdentifier:@"RealExaminationCell"];
    //[_tableView registerClass:[SubjectThreeVideoCell class] forCellReuseIdentifier:@"SubjectThreeVideoCell"];
    [_tableView registerClass:[SeekHelpCell class] forCellReuseIdentifier:@"SeekHelpCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    [_tableView setExtraCellLineHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    [self.view addSubview:_tableView];
   
    
}
-(void)subjectThreeVideoCell:(SubjectThreeVideoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel *)model
{
    HJLog(@"%@",model);
    
    SubjectDetailController *vc = [[SubjectDetailController alloc] init];
    
    vc.urlString = model.url;
    
    vc.titleString = model.title;
    
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return [SubjectThreeVideoCell getCellHeightWithData:self.videoArray];
    }
    if (indexPath.section == 1)
    {
        return (kScreenWidth-26)*0.3337+5+5;
    }
    else
    {
        return 240;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        SubjectThreeVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectThreeVideoCell" ];
        if (!cell) {
            cell = [[SubjectThreeVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubjectThreeVideoCell"];
        }
        cell.delegate = self;
        [cell configCellUIWithVideoModelArray:self.videoArray];
        cell.videoModelArray = self.videoArray;
        
        return cell;
    }
    if (indexPath.section == 1) {
        RealExaminationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RealExaminationCell" forIndexPath:indexPath];
        [cell.realExaminationBtn removeAllTargets];
        [cell.realExaminationBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.realExaminationBtn setImage:[UIImage imageNamed:@"学时陪练2"] forState:UIControlStateNormal];
        return cell;
        
    }else{
    
        static NSString * identifier = @"SeekHelpCell";
        SeekHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.subjectNumber = @"三";
        return cell;
        
    }
    
}
//设置区头区脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }if (section == 1) {
        return 148;
    }else {
        return 8;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 148)];
            self.bgView = bgView;
            bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
            //创建集合试图
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, 106) collectionViewLayout:layout];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            _collectionView.pagingEnabled = YES;
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.showsHorizontalScrollIndicator = NO;
            [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
            [bgView addSubview:_collectionView];
            
            //创建pageControl
            _pageControl = [[UIPageControl alloc] init];
            _pageControl.numberOfPages = self.articlesArray.count;
            _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#e0e5e4"];
            _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#5cb6ff"];
            [bgView addSubview:_pageControl];
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgView);
                make.bottom.offset(-5);
                make.width.offset(kScreenWidth);
            }];
        

        return _bgView;
    }
    else
    {
        return nil;
    }
    
    
    
}
-(void)seekHelpCellDidClickSendBtn:(SeekHelpCell *)cell
{
    if ([cell.textView.text isEqualToString:@""]||cell.textView.text == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"内容不能为空!" hideAfterDelay:1.0f];
        return;
    }
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在操作..."];
    
    NSString * url = self.interfaceManager.communityCreateUrl;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community/create" time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"communityType"] = @(0);
    paramDict[@"content"] = cell.textView.text;
    paramDict[@"anonymous"] = @(0);
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1)
        {
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
        }
        else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            
        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
    cell.textView.text = nil;

    
}
#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articlesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    ArticlesModel *model = self.articlesArray[indexPath.row];
    [cell.collectionImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"4x3比例"]];
    cell.collectionLab.text = model.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createTime];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat  =@"yyyy-MM-dd";
    [df stringFromDate:date];
    cell.dateLab.text = [df stringFromDate:date];
    cell.numberLab.text = [NSString stringWithFormat:@"%d",model.readCount];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(kScreenWidth, 106);
    return size;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticlesModel * articles = _articlesArray[indexPath.row];
    BaseWebController *vc = [[BaseWebController alloc]init];
    vc.urlString = articles.pageUrl;
    vc.titleString = articles.title;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)createNavigationBar {
    
    [self createCenterBtnNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"科目三" centerBtnSelector:@selector(centerBtnClick:) andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:nil withRightBtnTitle:nil];
    
}
- (void)leftBtnClick {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (CLDropDownMenu *)dropMenu {
    
    if (!_dropMenu) {
        _dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(kScreenWidth/2 , -128, 60, 120) Pressed:^(NSInteger index) {
            if (index == 0) {
                SubjectOneHomeVC * vc = [[SubjectOneHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }if (index == 1) {
                SubjectTwoHomeVC * vc = [[SubjectTwoHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }if (index == 2) {
                NSLog(@"跳转科目四");
                SubjectFourHomeVC * vc = [[SubjectFourHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        
        _dropMenu.removeFromSupviewHandle = ^(){
            
            _dropMenu = nil;
            
        };
        _dropMenu.direction = CLDirectionTypeBottom;
        _dropMenu.titleList = @[@"科目一",@"科目二",@"科目四"];
    }
    
    return _dropMenu;
    
    
}
- (void)centerBtnClick:(UIButton *)btn {
    
    if (!_dropMenu) {
        
        [self.view addSubview:self.dropMenu];
        
    }else {
        
        [self.dropMenu removeFromSuperview];
        self.dropMenu = nil;
    }
    
    
}

- (void)action:(UIButton *)btn
{
    
    PartnerTrainingVC *VC = [[PartnerTrainingVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    /*
    RealExaminationCell *cell = (RealExaminationCell *)btn.superview.superview;
    NSString *url = cell.dict[@"actionScript"];
    BaseWebController *baseVC = [[BaseWebController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@?app=1&uid=%@",url,kUid];
    baseVC.urlString = urlStr;
    baseVC.titleString = @"详情";
    [self.navigationController pushViewController:baseVC animated:YES];
     */
 
}


@end
