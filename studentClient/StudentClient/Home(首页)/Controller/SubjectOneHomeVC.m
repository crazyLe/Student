//
//  SubjectOneHomeVC.m
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectOneHomeVC.h"
#import "ItemPoolCell.h"
#import "Masonry.h"
#import <SDCycleScrollView.h>
#import "CollectionViewCell.h"
#import "SeekHelpCell.h"
#import "IQKeyBoardManager.h"

#import "SubjectOneExamHomeVC.h"
#import "SubjectExamController.h"
#import "SubjectOneMyMistakeVC.h"
#import "CLDropDownMenu.h"
#import "SubjectTwoHomeVC.h"
#import "SubjectThreeHomeVC.h"
#import "SubjectExamCollectionVC.h"
#import "ArticlesModel.h"
#import "BannersModel.h"
#import "BaseWebController.h"
#import "SubjectFourHomeVC.h"
@interface SubjectOneHomeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ItemPoolCellDelegate,SeekHelpCellDelegate> {

    
    UITableView * _tableView;
    SDCycleScrollView * _bannerView;
    UICollectionView * _collectionView;
    UIPageControl * _pageControl;
    NSTimer * _timer;
}

@property (nonatomic, strong) CLDropDownMenu *dropMenu;
@property (nonatomic, strong) NSMutableArray *articlesArray;
@property (nonatomic, strong) NSMutableArray *bannersArray;

@end

@implementation SubjectOneHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _articlesArray = [NSMutableArray array];
    _bannersArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    [self createNavigationBar];
    
    [self requestData];
        
    [self createTableView];

}

- (void)requestData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    NSString * url = self.interfaceManager.subjectsMainPage;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/subjectsMainPage" time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"subject"] = @"first";
    
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSArray * arr1 = dict[@"info"][@"articles"];
            _articlesArray = [ArticlesModel mj_objectArrayWithKeyValuesArray:arr1];
            NSArray * arr2 = dict[@"info"][@"banners"];
            _bannersArray = [BannersModel mj_objectArrayWithKeyValuesArray:arr2];
            
            [_tableView reloadData];
            [self.hudManager dismissSVHud];
            
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            
        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
    
    
}
- (void)addNSTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
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
    if (_timer == nil) {
        [self addNSTimer];
    }
}


#pragma mark -- 创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight ) style:UITableViewStyleGrouped];
    [_tableView registerClass:[ItemPoolCell class] forCellReuseIdentifier:@"ItemPoolCell"];
    [_tableView registerClass:[SeekHelpCell class] forCellReuseIdentifier:@"SeekHelpCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setExtraCellLineHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return  ((float)(kScreenWidth - 40*4)/3) + 22 +31 ;
    } else {
        return 240;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.283 * kScreenWidth;
    }else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        NSMutableArray * arr = [NSMutableArray array];
        for (int i = 0; i < _bannersArray.count; i++) {
            BannersModel * banners = _bannersArray[i];
            [arr addObject:banners.imgUrl];
        }
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.283*kScreenWidth) imageURLStringsGroup:arr];
        _bannerView.placeholderImage = [UIImage imageNamed:@"默认banner"];
        _bannerView.autoScrollTimeInterval = 3.0f;
        if (arr.count > 1) {
            _bannerView.infiniteLoop = YES;
        } else {
            _bannerView.infiniteLoop = NO;
        }
        _bannerView.autoScroll = YES;
        _bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerView.placeholderImage = nil;
        _bannerView.pageControlDotSize = CGSizeMake(10, 10);
        _bannerView.showPageControl = YES;
        _bannerView.hidesForSinglePage = YES;
        _bannerView.currentPageDotColor = [UIColor whiteColor];
        _bannerView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
        
        return _bannerView;
        
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 148;
    }else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 148)];
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
        _pageControl.numberOfPages =_articlesArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#e0e5e4"];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#5cb6ff"];
        [bgView addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.bottom.offset(-5);
            make.width.offset(kScreenWidth);
        }];
        
        
        return bgView;
    }else {
        return nil;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0) {
        
        static NSString * identifier = @"ItemPoolCell";
        ItemPoolCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

        cell.delegate = self;

        return cell;
    } else {
        
        static NSString * identifier = @"SeekHelpCell";
        SeekHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.subjectNumber = @"一";
        return cell;
    }
}

-(void)itemPoolCell:(ItemPoolCell *)cell didClickButtonWithType:(ItemPoolCellButtonType)type {

    switch (type) {
            
        case ItemPoolCellButtonOne:
        {
            
            SubjectExamCollectionVC * vc = [[SubjectExamCollectionVC alloc] init];
            
            vc.isSubjectOne = YES;
            
            vc.isExamination = NO;
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case ItemPoolCellButtonTwo:
        {
            
            SubjectOneExamHomeVC * vc = [[SubjectOneExamHomeVC alloc] init];
            
            vc.subjectNum = @"一";
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
            
            
        case ItemPoolCellButtonThree:
        {
            
            SubjectOneMyMistakeVC * vc = [[SubjectOneMyMistakeVC alloc] init];
            
            vc.subjectNum = @"1";
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
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
}

#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _articlesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    ArticlesModel * articles = _articlesArray[indexPath.row];
    [cell.collectionImgView sd_setImageWithURL:[NSURL URLWithString:articles.imgUrl] placeholderImage:[UIImage imageNamed:@"4x3比例"]];
    cell.collectionLab.text = articles.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:articles.createTime];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat  =@"yyyy-MM-dd";
    [df stringFromDate:date];
    cell.dateLab.text = [df stringFromDate:date];
    cell.numberLab.text = [NSString stringWithFormat:@"%d",articles.readCount];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticlesModel * articles = _articlesArray[indexPath.row];
    BaseWebController *vc = [[BaseWebController alloc]init];
    vc.urlString = articles.pageUrl;
    vc.titleString = articles.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(kScreenWidth, 106);
    return size;
    
}

- (void)createNavigationBar {
    
    [self createCenterBtnNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick)  andCenterTitle:@"科目一" centerBtnSelector:@selector(centerBtnClick:) andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:nil withRightBtnTitle:nil];
    

}
- (void)menuBtnClick {
    
}
- (void)leftBtnClick {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (CLDropDownMenu *)dropMenu {
    
    if (!_dropMenu) {
        _dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(kScreenWidth/2 , -128, 60, 120) Pressed:^(NSInteger index) {
            if (index == 0) {
                SubjectTwoHomeVC * vc = [[SubjectTwoHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }if (index == 1) {
                SubjectThreeHomeVC * vc = [[SubjectThreeHomeVC alloc] init];
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
        _dropMenu.titleList = @[@"科目二",@"科目三",@"科目四"];
    }
    
    return _dropMenu;
    
    
}
- (void)centerBtnClick:(UIButton *)btn {
    
    if (!_dropMenu) {
        [self.view addSubview:self.dropMenu];

    } else {
        [self.dropMenu removeFromSuperview];
        self.dropMenu = nil;
    }
}


@end
