//
//  OSAddressPickerView.m
//  AddressPicker
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 筒子家族. All rights reserved.
//

#import "OSAddressPickerView.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation OSAddressPickerView
{
    //装的是Model
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;
    
    NSString  *_currentProvince;
    NSString  *_currentCity;
    NSString  *_currentDistrict;
    
    //用于返回
    ProvinceModel  *_currentProvinceModel;
    CityModel  *_currentCityModel;
    CountryModel  *_currentDistrictModel;
    
    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;
}

+ (id)shareInstance
{
    static OSAddressPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[OSAddressPickerView alloc] init];
    });
    
    return shareInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBottomView)];
        [self addGestureRecognizer:tap];
        
        [self createView];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    
    if (_dataArray == nil) {
        
        _dataArray = dataArray;
        
        _provinces = self.dataArray;
        
        // 第一个省分对应的全部市
        _citys = ((ProvinceModel *)[_provinces objectAtIndex:0]).citys;

        // 第一个省份
        _currentProvince = ((ProvinceModel *)[_provinces objectAtIndex:0]).name;
        _currentProvinceModel = ((ProvinceModel *)[_provinces objectAtIndex:0]);

        // 第一个省份对应的第一个市
        _currentCity = ((CityModel *)[_citys objectAtIndex:0]).name;
        _currentCityModel = ((CityModel *)[_citys objectAtIndex:0]);

        // 第一个省份对应的第一个市对应的第一个区
        _areas = ((CityModel *)[_citys objectAtIndex:0]).countrys;
        if (_areas.count > 0) {
            _currentDistrict = ((CountryModel *)[_areas objectAtIndex:0]).name;
            
            _currentDistrictModel = ((CountryModel *)[_areas objectAtIndex:0]);

        } else {
            _currentDistrict = @"";
        }
    }
    
    

}
- (void)createView
{
    // 弹出的整个视图
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250)];
    [self addSubview:_wholeView];
    
    // 头部按钮视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_wholeView addSubview:_topView];
    
    // 防止点击事件触发
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_topView addGestureRecognizer:topTap];
    
    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor groupTableViewBackgroundColor];
        button.frame = CGRectMake(i*(ScreenWidth-50), 0, 50, 40);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [_topView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 240-40)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_wholeView addSubview:_pickerView];
}

- (void)buttonEvent:(UIButton *)button
{
    // 点击确定回调block
    if (button.tag == 1)
    {
        if (_block) {
            _block(_currentProvinceModel, _currentCityModel, _currentDistrictModel);
        }
    }
    
    [self hiddenBottomView];
}

- (void)showBottomView
{
    [UIView animateWithDuration:0.3 animations:^
    {
        _wholeView.frame = CGRectMake(0, ScreenHeight-240-64, ScreenWidth, 240);
        
    } completion:^(BOOL finished) {}];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"address"]) {
        [self refreshPickerView:[defaults objectForKey:@"address"]];
    }
}

- (void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^
    {
        _wholeView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 250);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)refreshPickerView:(NSString *)address
{
    NSArray *addressArray = [address componentsSeparatedByString:@" "];
    NSString *provinceStr = addressArray[0];
    NSString *cityStr = addressArray[1];
    NSString *districtStr = addressArray[2];
    
    int oneColumn=0, twoColumn=0, threeColum=0;
    
    // 省份
    for (int i=0; i<_provinces.count; i++)
    {
        ProvinceModel *model = _provinces[i];
        if ([provinceStr isEqualToString:model.name]) {
            oneColumn = i;
        }
    }
    
    // 用来记录是某个省下的所有市
    ProvinceModel *provinceModel = _provinces[oneColumn];
    NSArray *tempArray = provinceModel.citys;
    // 市
    for  (int j=0; j<[tempArray count]; j++)
    {
        CityModel *cityModel = tempArray[j];
        if ([cityStr isEqualToString:cityModel.name])
        {
            twoColumn = j;
            break;
        }
    }
    
    // 区
    for (int k=0; k<((CityModel *)tempArray[twoColumn]).countrys.count; k++)
    {
        if ([districtStr isEqualToString:((CountryModel *)((CityModel *)tempArray[twoColumn]).countrys[k]).name])
        {
            threeColum = k;
            break;
        }
    }
    
    [self pickerView:_pickerView didSelectRow:oneColumn inComponent:0];
    [self pickerView:_pickerView didSelectRow:twoColumn inComponent:1];
    [self pickerView:_pickerView didSelectRow:threeColum inComponent:2];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_citys count];
            break;
        case 2:
            
            return [_areas count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return ((ProvinceModel *)[_provinces objectAtIndex:row]).name;
            break;
        case 1:
            return ((CityModel *)[_citys objectAtIndex:row]).name;
            break;
        case 2:
            if ([_areas count] > 0) {
                return ((CountryModel *)[_areas objectAtIndex:row]).name;
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView selectRow:row inComponent:component animated:YES];
    
    switch (component)
    {
        case 0:
            
            _citys = ((ProvinceModel *)[_provinces objectAtIndex:row]).citys;
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView reloadComponent:1];
            
            _areas = ((CityModel *)[_citys objectAtIndex:0]).countrys;
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentProvince = ((ProvinceModel *)[_provinces objectAtIndex:row]).name;
            _currentProvinceModel = ((ProvinceModel *)[_provinces objectAtIndex:row]);
            _currentCity = ((CityModel *)[_citys objectAtIndex:0]).name;
            _currentCityModel = ((CityModel *)[_citys objectAtIndex:0]);
            if ([_areas count] > 0) {
                _currentDistrict =  ((CountryModel *)[_areas objectAtIndex:0]).name;
                _currentDistrictModel = ((CountryModel *)[_areas objectAtIndex:0]);
            } else{
                _currentDistrict = @"";
            }
            break;
            
        case 1:
            
            _areas = ((CityModel *)[_citys objectAtIndex:row]).countrys;
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentCity = ((CityModel *)[_citys objectAtIndex:row]).name;
            _currentCityModel = ((CityModel *)[_citys objectAtIndex:row]);

            if ([_areas count] > 0) {
                _currentDistrict = ((CountryModel *)[_areas objectAtIndex:0]).name;
                _currentDistrictModel = ((CountryModel *)[_areas objectAtIndex:0]);

            } else {
                _currentDistrict = @"";
            }
            break;
            
        case 2:
            
            if ([_areas count] > 0) {
                _currentDistrict = ((CountryModel *)[_areas objectAtIndex:row]).name;
                _currentDistrictModel = ((CountryModel *)[_areas objectAtIndex:row]);

            } else{
                _currentDistrict = @"";
            }
            break;
            
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

@end
