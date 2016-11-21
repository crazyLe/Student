//
//  BAddressPickerController.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "ChineseToPinyin.h"
#import "LLOpenCityModel.h"
#import "LLSelectCityViewController.h"
#import "LLAddress.h"
#import "BAddressPickerController.h"
#import "ChineseToPinyin.h"
#import "BAddressHeader.h"
#import "BCurrentCityCell.h"
#import "BRecentCityCell.h"
#import "BHotCityCell.h"


@interface BAddressPickerController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    NSMutableArray *hotCities;
    NSMutableArray *cities;
    NSMutableArray *titleArray;
    NSMutableArray *resultArray;
}

@property(nonatomic, strong) NSMutableDictionary *dictionary;

@property(nonatomic, strong) NSMutableDictionary *modelDictionary;

@property(nonatomic, strong) NSArray *allOpenCityArr;

@end

@implementation BAddressPickerController

/**
 *  初始化方法
 *
 *  @param frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        [self initData];
        [self initSearchBar];
        [self initTableView];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentCity];
    }
    return self;
}

#pragma mark - Getter and Setter
/*
- (void)setDataSource:(id<BAddressPickerDataSource>)dataSource{
    hotCities = [dataSource arrayOfHotCitiesInAddressPicker:self];
    [_tableView reloadData];
}
*/

#pragma mark - UISearchBar Delegate
/**
 *  搜索开始回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view setBackgroundColor:UIColorFromRGBA(198, 198, 203, 1.0)];
                for (UIView *subview in self.view.subviews){
                    if (_searchBar==subview) {
                        subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                    }
                    
                }
            }];
        }
    }
    return YES;
}

/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (isEmptyStr(searchBar.text)) {
        [self resumeToNormalStatusWithSearchBar:searchBar];
    }
    return YES;
}

/**
 *  点击取消
 *
 *  @param searchBar
 *
 *  @return
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self resumeToNormalStatusWithSearchBar:searchBar];
}

- (void)resumeToNormalStatusWithSearchBar:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(endSearch:)]) {
        [self.delegate endSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            } completion:^(BOOL finished) {
                [self.view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [resultArray removeAllObjects];
//    for (int i = 0; i < cities.count; i++) {
//        if ([[ChineseToPinyin pinyinFromChiniseString:cities[i]] hasPrefix:[searchString uppercaseString]] || [cities[i] hasPrefix:searchString]) {
//            [resultArray addObject:[cities objectAtIndex:i]];
//        }
//    }
    
    for (int i = 0; i < _allOpenCityArr.count; i++) {
        NSDictionary *cityDic = _allOpenCityArr[i];
        if ([cityDic[@"pinyin"] hasPrefix:[searchString lowercaseString]] || [cityDic[@"name"] hasPrefix:searchString]) {
            [resultArray addObject:cityDic[@"name"]];
        }
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return [[self.dictionary allKeys] count] + 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section > 2) {
            NSString *cityKey = [titleArray objectAtIndex:section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            return [array count];
        }
        if (section == 2) {
     
            return 1;
//            return [hotCities count];
        }
        return 1;
    }else{
        return [resultArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            BCurrentCityCell *currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
            if (currentCityCell == nil) {
                currentCityCell = [[BCurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currentCityCell"];
            }
            currentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return currentCityCell;
        }else if (indexPath.section == 1){
            BRecentCityCell *recentCityCell = [tableView dequeueReusableCellWithIdentifier:@"recentCityCell"];
            if (recentCityCell == nil) {
                recentCityCell = [[BRecentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentCityCell"];
            }
            recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                recentCityCell.frame = CGRectMake(0, 0, 0, 0);
                [recentCityCell setHidden:YES];
//            }
            return recentCityCell;
        }else if (indexPath.section == 2){
            BHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
            if (hotCell == nil) {
                hotCell = [[BHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell" array:hotCities];
            }
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
//            HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
//            if (cell == nil) {
//                cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell"];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *Identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if ([cell isKindOfClass:[BCurrentCityCell class]]) {
            [(BCurrentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else if ([cell isKindOfClass:[BRecentCityCell class]]){
            [(BRecentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }
        else if([cell isKindOfClass:[BHotCityCell class]]){
            [(BHotCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }
//        else if([cell isKindOfClass:[HotCityCell class]]){
//           
//            cell.textLabel.text = [hotCities objectAtIndex:indexPath.row];
//            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
//            
//        }
        else{
            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }

    }else{
        cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
//        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"当前",@"最近",@"热门", nil];
         NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"当前",@"",@"热门", nil];
        for (int i = 0; i < [titleArray count]; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",[titleArray objectAtIndex:i]];
            [titleSectionArray addObject:title];
        }
        return titleSectionArray;
    }else{
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
        headerView.backgroundColor = UIColorFromRGBA(235, 235, 235, 1.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 28)];
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        if (section == 0) {
            label.text = @"当前城市";
        }else if (section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return nil;
            }
//            label.text = @"最近访问城市";
            label.text = @"";
        }else if (section == 2){
            label.text = @"热门城市";
//            label.text = @"";
        }else{
            label.text = [titleArray objectAtIndex:section - 3];
        }
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 1) {
            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//                return 0.01;
//            }
            return CGFLOAT_MIN;
        }
        else if (section == 2)
        {
            //热门城市
//            return 0.01f;
        }
        else if( section > 2 )
        {
            NSString *cityKey = [titleArray objectAtIndex:section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            return array.count==0?0.01f:28;
        }
        return 28;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        //如果第一次使用没有最近访问的城市则赢该行
        if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
            return 0.01;
        }
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 2) {
            return ceil((float)[hotCities count] / 3) * (BUTTON_HEIGHT + 15) + 15;
//            return 42;
        }else if (indexPath.section > 2){
            return 42;
        }else if (indexPath.section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//                return 0;
//            }
            //最近访问城市
            return CGFLOAT_MIN;
        }
        return BUTTON_HEIGHT + 30;
    }else{
        return 42;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        if (indexPath.section > 2) {
//            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 3];
//            NSArray *array = [self.dictionary objectForKey:cityKey];
//            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
//                [self saveCurrentCity:[array objectAtIndex:indexPath.row]];
//                [self.delegate addressPicker:self didSelectedCity:[array objectAtIndex:indexPath.row]];
//            }
            
            LLSelectCityViewController *selectCityVC = [[LLSelectCityViewController alloc] init];
            NSArray *cityArr = self.modelDictionary[titleArray[indexPath.section-3]];
            selectCityVC.provinceModel = cityArr[indexPath.row];
            selectCityVC.delegate = self;
            [self.navigationController pushViewController:selectCityVC animated:YES];
        }
        if (indexPath.section == 2) {//热门城市
            NSLog(@"%@",hotCities);
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self saveCurrentCity:hotCities[indexPath.row]];
                [self.delegate addressPicker:self didSelectedCity:hotCities[indexPath.row]];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
            [self saveCurrentCity:[resultArray objectAtIndex:indexPath.row]];
            [self.delegate addressPicker:self didSelectedCity:[resultArray objectAtIndex:indexPath.row]];
        }
    }
}

//保存访问过的城市
- (void)saveCurrentCity:(NSString*)city{
    NSMutableArray *currentArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:currentCity]];
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
    if ([currentArray count] < 2 && ![currentArray containsObject:city]) {
        [currentArray addObject:city];
    }else{
        if (![currentArray containsObject:city]) {
            currentArray[1] = currentArray[0];
            currentArray[0] = city;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentArray forKey:currentCity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - init
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight -64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    [self.view addSubview:_tableView];
    [self.view sendSubviewToBack:_tableView];
}

- (void)initSearchBar{
    resultArray = [[NSMutableArray alloc] init];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

- (void)initData{
    /*
    cities = [[NSMutableArray alloc] init];
    NSArray *allCityKeys = [self.dictionary allKeys];
    for (int i = 0; i < [self.dictionary count]; i++) {
        [cities addObjectsFromArray:[self.dictionary objectForKey:[allCityKeys objectAtIndex:i]]];
    }
     */
    
    //准备热门城市数据源
    hotCities = [[NSMutableArray alloc] init];

    //准备所有开放城市数据源
    cities = [[NSMutableArray alloc] init];
    _allOpenCityArr = [[SCDBManager shareInstance] getAllObjectsFromTable:kOpenCityTableName KeyArr:kOpenCityTableColumnArr];
    for (NSDictionary *dic in _allOpenCityArr) {
        if (!isEmptyStr(dic[@"name"])) {
            [cities addObject:dic[@"name"]];
        }
        if ([dic[@"hot"] intValue]==1) {
            //是热门城市
            [hotCities addObject:dic[@"name"]];
        }
    }
    
    //准备区头数据源
    titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        if (i == 8 || i == 14 || i == 20 || i== 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        if ([[self.dictionary allKeys] containsObject:cityKey]) {
            [titleArray addObject:cityKey];
        }
    }
}

#pragma mark - Getter and Setter
- (NSMutableDictionary*)dictionary{
    if (_dictionary == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
//        _dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        _dictionary = [self getOpenProvinceDictionary];
        
    }
    return _dictionary;
}

//获取开放城市字典  eg. @{@"A":@[@"安徽省"],@"J":@[@"江苏省"]}
- (NSMutableDictionary *)getOpenProvinceDictionary
{
    SCDBManager *db_manager = [SCDBManager shareInstance];
//    NSArray *openCityArr = [db_manager getAllObjectsFromTable:kOpenCityTableName KeyArr:kOpenCityTableColumnArr];
    
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in _allOpenCityArr) {
//       NSString *short_name = [db_manager getValueInTable:kProvinceTableName WhereItsKey:@"id" IsValue:dic[@"parent_id"] TargetKey:@"short_name"];
        NSDictionary *getProvinceDic = [db_manager getValueInTable:kProvinceTableName WhereItsKey:@"id" IsValue:dic[@"parent_id"] columnArr:kProvinceTableCollumnArr];
        if (![nameArr containsObject:getProvinceDic[@"short_name"]]) {
           LLOpenCityModel *model = [LLOpenCityModel mj_objectWithKeyValues:getProvinceDic];
            [modelArr addObject:model];
            [nameArr addObject:getProvinceDic[@"short_name"]];
        }
    }
    
    NSMutableDictionary *openCityDic = [NSMutableDictionary dictionary];
    
    _modelDictionary = [NSMutableDictionary dictionary];
    
    for (LLOpenCityModel *model in modelArr) {
        NSString *pinyin_prefix = [model.pinyin substringToIndex:1];
        
        pinyin_prefix = [pinyin_prefix uppercaseString];
        
        NSMutableArray *provinceArr = openCityDic[pinyin_prefix];
        
        NSMutableArray *provinceModelArr = _modelDictionary[pinyin_prefix];
        if (provinceArr) {
            [provinceArr addObject:model.name];
            
            [provinceModelArr addObject:model];
        }
        else
        {
            provinceArr = [NSMutableArray array];
            [provinceArr addObject:model.name];
            [openCityDic setObject:provinceArr forKey:pinyin_prefix];
            
            provinceModelArr = [NSMutableArray array];
            [provinceModelArr addObject:model];
            [_modelDictionary setObject:provinceModelArr forKey:pinyin_prefix];
        }
    }
    
    return openCityDic;
}

#pragma mark - LLSelectCityViewControllerDelegate

- (void)LLSelectCityViewController:(LLSelectCityViewController *)vc didSelectCity:(LLOpenCityModel *)selectCityModel;
{
    if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
        [self saveCurrentCity:selectCityModel.name];
        [self.delegate addressPicker:self didSelectedCity:selectCityModel.name];
    }
}

@end


@implementation HotCityCell



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
