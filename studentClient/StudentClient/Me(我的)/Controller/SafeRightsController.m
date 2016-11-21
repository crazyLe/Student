//
//  SafeRightsController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SafeRightsController.h"
#import "SafeRightsCell.h"
#import "SafeRightsHeadCell.h"
#import "SafeRightModel.h"

#define kHeadImageHeight 310

@interface SafeRightsController ()<UITableViewDelegate,UITableViewDataSource,SafeRightsCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray * safeArray;

@end

@implementation SafeRightsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self setBg_TableView];
    [self addTableHeadView];
    self.safeArray = [NSMutableArray array];
    [self initWithData];
}
- (void)setBg_TableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setCellLineFullInScreen];
    
    [self.tableView setExtraCellLineHidden];
    
    tableView.backgroundColor = BG_COLOR;
    
    tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    
    tableView.sectionHeaderHeight = 9*kHeightScale;
    
    [self.view addSubview:tableView];

}

-(void)addTableHeadView
{
    
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight);
    
    self.imageView.image = [UIImage imageNamed:@"weiquan-banner"];
    
    [self.tableView addSubview:self.imageView];
    
    //设置图片的模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    self.imageView.clipsToBounds = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -kHeadImageHeight)];

}

- (void)setNavigation
{
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"驾考维权"];
    //设置y值从屏幕最上方开始
    if (IOS7_OR_LATER && [self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    //开启导航栏透明。使得y值从最上方开始
    [self.navigationController.navigationBar setTranslucent:YES];
    //设置导航栏渲染色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}

- (void)clickSafeRightsCellPhoneBtn:(NSString *)telPhone
{
    NSLog(@" 打电话");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", telPhone]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)initWithData
{
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.getFend;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"ver"] = [[UIDevice currentDevice] systemVersion];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            self.safeArray = [SafeRightModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
            [_tableView reloadData];
            [self.hudManager dismissSVHud];
            
        }
        else
        {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
}
/**
 *  核心代码
 *
 *  @param scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.tableView.contentOffset.y);
    
    CGFloat offSet_Y = self.tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight) {
        //获取imageView的原始frame
        CGRect frame = self.imageView.frame;
        //修改y
        frame.origin.y = offSet_Y;
        //修改height
        frame.size.height = -offSet_Y;
        //重新赋值
        self.imageView.frame = frame;
        
    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight;
    
    NSLog(@"%f",reoffSet);
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    CGFloat alpha = reoffSet/(kHeadImageHeight-64);
    
    NSLog(@"%f",alpha);
    
    if (alpha>=1) {
        alpha = 0.99;
    }
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"353c3f" alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- tableView的代理和数据源
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _safeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else
    {
        return 80;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        static NSString *ID = @"SafeRightsHeadCell";
        SafeRightsHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SafeRightsHeadCell" owner:nil options:nil]lastObject];
        }
        SafeRightModel * model = _safeArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoLabel.text = model.title;
        return cell;
 
    }
    else
    {
        static NSString *ID = @"SafeRightsCell";
        SafeRightsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SafeRightsCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _safeArray[indexPath.section];
        return cell;
    
    }
    
}




@end
