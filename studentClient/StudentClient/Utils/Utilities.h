//
//  Utilities.h
//  学员端
//
//  Created by 高斌 on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
//根据颜色字符串转成UIColor
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//根据颜色值返回一张图片
+ (UIImage *)imageWithColor:(UIColor *)color;
//计算高度---按字换行(固定宽度,固定字体大小)
+(CGSize)getSizeWithText:(NSString *)textString width:(NSInteger)width fontSize:(NSInteger)fontSize;
//获取指定宽高的图片
+ (NSString *)getImageUrl:(NSString *)url withW:(NSInteger)width withH:(NSInteger)height;
//转时间
+ (NSString *)calculateTimeWithDay:(NSString *)dateString;
//转时间 任务与审批
+ (NSString *)calculateTimeWithFaceTimeDayTarget:(NSString *)dateString;
//获取通讯录并上传到服务器
+ (BOOL)getContactsList;
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
//根据秒数返回 时:分:秒
+(NSString *)getTimeStringWithSecond:(NSInteger)second;
//检查网络状态
+(NSString *)getNetWorkStates;
/**
 *截取view一部分转成image
 */
+ (UIImage *)cutDownScreenView:(UIView *)view rect:(CGRect)rect;

+ (UILabel *)addLabelWithRect:(CGRect)rect text:(NSString *)text font:(NSInteger)fontSize color:(NSString *)colorStr alignment:(NSTextAlignment)alignment backColor:(NSString *)backColor numbersLine:(NSInteger)number parentView:(UIView *)parentView;
//画虚线
+ (UIImageView *)drawDashLineWithRect:(CGRect)rect WithColor:(UIColor *)color parentView:(UIView *)parentView;
//检测手机上面安装的地图
+(NSArray *)checkHasOwnApp;
//把时间转化成当前时间时分秒形式
+(NSString *)fixStringForDateHms:(NSDate *)date;
//把时间转化成当前时间年月日形式
+ (NSString *)fixStringForDateYmd:(NSDate *)date;
//把时间转化成年月日时分形式
+ (NSString *)fixStringForDateyMdHm:(NSDate *)date;
//获取当前系统的yyyy-MM-dd格式时间
+(NSString *)getTime;
+(NSString *)getSizeStringWithString:(NSString *)oldString;
//根据生日计算星座
+(NSString *)getXingzuo:(NSDate *)in_date;
//根据出生年月计算生肖
+(NSString *)getChineseZodiac:(NSDate *)date;
//错误提示展示
+ (void)IDHUDShowFailCustomViewState:(UIView *)parentView
                           WithTitle:(NSString *)title
                               delay:(NSTimeInterval)delay
                            animaton:(BOOL)animation;
//替换特殊字符
+(NSString *)getReplaceXMLCharacter:(NSString *)chaString;
//根据imageSize裁剪image
+ (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage size:(CGSize)imageSize;
//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
//剪切图片(从中心算起）
+ (UIImage *)getCutImageSize:(CGSize)size originalImage:(UIImage *)originalImage;



@end
