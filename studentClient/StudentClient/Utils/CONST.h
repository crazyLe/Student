//
//  CONST.h
//  
//
//  Created by zwz on 15/8/20.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#ifndef _____________CONST_h
#define _____________CONST_h

//版本号code码
#define versioncode @"2"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavHeight 64
#define kTabBarHeight 49
#define BG_COLOR [UIColor colorWithHexString:@"#f2f7f6"]


/**
 * 宽度适配宏定义
 */
#define AutoSizeScaleX (kScreenWidth/375)  //以iphone6来适配
/**
 * 高度适配宏定义
 */
#define AutoSizeScaleY (kScreenHeight/667) //以iphone6来适配
/**
 * 字体适配宏定义
 */
#define AutoSizeFont AutoSizeScaleX //以iphone6来适配

/** 是否是3.5屏幕*/
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 是否是4.0屏幕*/
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/** 是否是4.7屏幕*/
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
/** 是否是5.5屏幕*/
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
/** 是否是iPad*/
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
//随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------颜色类--------------------------


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:A ofType:nil］

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


//----------------------其他----------------------------
//GCD 的宏定义

//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

//弱引用&强引用

#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;


//方正黑体简体字体定义

#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//设置View的tag属性

#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]

//程序的本地化,引用国际化的文件

#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//通知中心
#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

//Format简写

#define Format(string, args...)                  [NSString stringWithFormat:string, args]

//用于划线时的高度在不同机型适配

#define LINE_HEIGHT (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?0.5:1)

//用于定义collectionViewCell分割线使用
#define kTableViewSeparaterLineColor [UIColor colorWithRed:0.70f green:0.70f blue:0.70f alpha:1.00f]

//判断设备的操做系统是不是ios7

#define IOS7_OR_LATER [[UIDevice currentDevice].systemVersion doubleValue]>=7.0

//判断 iOS 8 或更高的系统版本

#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

#define CurrentDeviceSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

//当前系统语言

#define  CurrentLanguage  ([[NSLocale  preferredLanguages]  objectAtIndex:0])

//区分模拟器和真机

#if  TARGET_OS_IPHONE
//iPhone  Device
#endif
#if  TARGET_IPHONE_SIMULATOR
//iPhone  Simulator
#endif

//cell的accessory宽度常量

#define kCellAccessoryDisclosureIndicatorWidth 33


//本地化宏定义

#define LocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define LocalizedStringFromTable(key, tbl, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]
#define LocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
[bundle localizedStringForKey:(key) value:@"" table:(tbl)]
#define LocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
[bundle localizedStringForKey:(key) value:(val) table:(tbl)]

//由角度获取弧度 有弧度获取角度

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//单例声明

#define singletonInterface(className) + (instancetype)shared##className;

//单例实现

#define singletonImplementation(className)\
static className *_instance;\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (instancetype)shared##className\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
    return _instance;\
}

//基本类型转String/Number
#define integerToStr(para) [NSString stringWithFormat:@"%ld",para]
#define intToStr(para)     [NSString stringWithFormat:@"%d",para]
#define floatToStr(para)   [NSString stringWithFormat:@"%f",para]
#define doubleToStr(para)  [NSString stringWithFormat:@"%f",para]
#define numToStr(para)     [NSString stringWithFormat:@"%@",para]
#define strToNum(para)     [NSNumber numberWithString:para]

//空判断相关
#define isEmptyStr(str) (!str||[str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) //判断是否空字符串
#define isEmptyArr(arr) (!arr||((NSArray *)arr).count==0) //判断是否空数组
#define isNull(str)     (!str||[str isKindOfClass:[NSNull class]])

//自定义Log
#ifdef DEBUG
#define HJLog(format, ...) {NSLog((@" 输出:" format @" 方法名:%s  行数:%d" ),##__VA_ARGS__,__PRETTY_FUNCTION__,__LINE__);}
#else
#define HJLog(...)
#endif

//解决AFNetworking报错问题
#ifndef TARGET_OS_IOS
#define TARGET_OS_IOS TARGET_OS_IPHONE
#endif
#ifndef TARGET_OS_WATCH
#define TARGET_OS_WATCH 0
#endif

#if DEBUG
#define MCRelease(x) [x release]
#else
#define MCRelease(x) [x release], x = nil
#endif

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  项目(因项目不同需要不同的宏定义，写在此处)
 */
#define TEXTFIELD_H 45
#define CORNERRADIUS 8

#define WeakObj(o) __weak typeof(o) o##Weak = o;
#define StrongObj(o)  __strong typeof(o) o = o##Weak;

#define kWidthScale kScreenWidth/320
#define kHeightScale kScreenHeight/568

#define kFont10 [UIFont systemFontOfSize:10*kWidthScale]
#define kFont11 [UIFont systemFontOfSize:11*kWidthScale]
#define kFont12 [UIFont systemFontOfSize:12*kWidthScale]
#define kFont13 [UIFont systemFontOfSize:13*kWidthScale]
#define kFont14 [UIFont systemFontOfSize:14*kWidthScale]
#define kFont15 [UIFont systemFontOfSize:15*kWidthScale]
#define kFont16 [UIFont systemFontOfSize:16*kWidthScale]
#define kFont17 [UIFont systemFontOfSize:17*kWidthScale]
#define kFont18 [UIFont systemFontOfSize:18*kWidthScale]
#define kFont19 [UIFont systemFontOfSize:19*kWidthScale]
#define kFont20 [UIFont systemFontOfSize:20*kWidthScale]
#define kFont42 [UIFont systemFontOfSize:42*kWidthScale]


#define kUid (([USER_DEFAULT objectForKey:@"uid"])==nil?@"0":([USER_DEFAULT objectForKey:@"uid"]))
#define kToken ([USER_DEFAULT objectForKey:@"token"])
#define kMobile ([USER_DEFAULT objectForKey:@"mobile"])
#define kPwd ([USER_DEFAULT objectForKey:@"pwd"])

#define kQuestionErrorRateTimeString ([USER_DEFAULT objectForKey:@"QuestionErrorRateTime"])

#define kCurrentLocationCity ([USER_DEFAULT objectForKey:@"locationCity"])
//登录状态  1代表登录
#define kLoginStatus ([USER_DEFAULT objectForKey:@"isLogin"])

//市字典
//#define kCityDict [USER_DEFAULT objectForKey:@"cityDict"]
//省字典
//#define kProvinceDict [USER_DEFAULT objectForKey:@"provinceDict"]
//县字典
//#define kCountryDict [USER_DEFAULT objectForKey:@"countryDict"]

//#define kAddressData [USER_DEFAULT objectForKey:@"addressArray"]
//beans——show
#define kBeansShow ([[USER_DEFAULT objectForKey:@"BeansShow"] boolValue])

//空判断相关
#define isEmptyStr(str) (!str||[str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) //判断是否空字符串
#define isEmptyArr(arr) (!arr||((NSArray *)arr).count==0) //判断是否空数组
#define isNull(str)     (!str||[str isKindOfClass:[NSNull class]])

#define kHandleEmptyStr(str) (isEmptyStr(str)?@"":str)  //解决空字符串问题
#define kEmptyStrToZero(str) (isEmptyStr(str)?@"0":str)  //解决空字符串问题

//文件管理相关
#define kFileManager [NSFileManager defaultManager]

#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory\
, NSUserDomainMask, YES)[0]

/*******************城市相关*************************/

#define kUserDefault USER_DEFAULT

//城市相关
#define kCityName      [kUserDefault objectForKey:@"CoachAreaName"]      //城市名 全称
#define kCityID        [kUserDefault objectForKey:@"CoachAreaID"]        //城市ID
#define kCityShortName [kUserDefault objectForKey:@"CoachAreaShortName"] //城市名 简称

#define kAreaVersion   [kUserDefault objectForKey:@"CoachAreaVersion"]   //地区版本号
#define cacheProvinceDataKey @"cacheProvinceDataKey"
#define cacheCityDataKey @"cacheCityDataKey"
#define cacheCountyDataKey @"cacheCountyDataKey"

//开放城市已改为市字典
#define kOpenCityTableName @"OpenCityTable"
#define kOpenCityTableColumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kCityDict [[SCDBManager shareInstance] getAllObjectsFromTable:kOpenCityTableName KeyArr:kOpenCityTableColumnArr]

//省字典
#define kProvinceTableName @"kProviceTableName"
#define kProvinceTableCollumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kProvinceDict [[SCDBManager shareInstance] getAllObjectsFromTable:kProvinceTableName KeyArr:kProvinceTableCollumnArr]

//县字典
#define kCountyTableName @"kCountyTableName"
#define kCountyTableCollumnArr @[@"id",@"hot",@"level",@"name",@"parent_id",@"pinyin",@"short_name",@"title"]
#define kCountryDict [[SCDBManager shareInstance] getAllObjectsFromTable:kCountyTableName KeyArr:kCountyTableCollumnArr]

#define kProvinceData [kUserDefault objectForKey:@"addressArray"]

#define kAddressData kProvinceData

#define getxueyuanAddressUrl [[HJInterfaceManager sharedHJInterfaceManager] getAddressUrl]

#endif
