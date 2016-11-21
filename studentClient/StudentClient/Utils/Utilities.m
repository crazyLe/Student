//
//  Utilities.m
//  学员端
//
//  Created by 高斌 on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "Utilities.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "sys/sysctl.h"
#import "MBProgressHUD.h"

@implementation Utilities
//根据颜色字符串转成UIColor
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
//根据颜色值返回一个image
+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//计算高度---按字换行
+(CGSize)getSizeWithText:(NSString *)textString width:(NSInteger)width fontSize:(NSInteger)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize maxSize = [textString  boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    maxSize.height = ceil(maxSize.height);
    return maxSize;
}
//图片宽高处理
+ (NSString *)getImageUrl:(NSString *)url withW:(NSInteger)width withH:(NSInteger)height{
    NSArray * suffixNameArray = [url componentsSeparatedByString:@"."];
    if ([[suffixNameArray lastObject] isEqualToString:@"gif"] || [[suffixNameArray lastObject] isEqualToString:@"GIF"]){
        return url;
    }
    //else if ([[suffixNameArray lastObject] isEqualToString:@"webp"] || [[suffixNameArray lastObject] isEqualToString:@"WEBP"]){
    //    return url;
    //}
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@_%zdx%zd.%@",url,height*3,width*3,[suffixNameArray lastObject]]);
    return [NSString stringWithFormat:@"%@_%zdx%zd.%@",url,height*3,width*3,[suffixNameArray lastObject]];
    
}
//新版消息列表转时间
+ (NSString *)calculateTimeWithDay: (NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * destDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    greCalendar.firstWeekday = 2;
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents *dateComponents = [greCalendar components:unitFlags fromDate:destDate];
    NSDateComponents *currentDateComponents = [greCalendar components:unitFlags fromDate:[NSDate date]];
    NSString * destDateString = nil;
    if (dateComponents.year == currentDateComponents.year && dateComponents.month == currentDateComponents.month && dateComponents.day == currentDateComponents.day){
        destDateString = @"今天";
    }else{
        NSDateComponents * tempDateComponents = [[NSDateComponents alloc] init];
        [tempDateComponents setDay:-1];
        NSDate *newDate = [greCalendar dateByAddingComponents:tempDateComponents toDate:[NSDate date] options:0];
        NSDateComponents *dateComponents1 = [greCalendar components:unitFlags fromDate:newDate];
        if (dateComponents1.year==dateComponents.year && dateComponents1.month==dateComponents.month && dateComponents1.day == dateComponents.day){
            destDateString = @"昨天";
        }else
        {
            if (dateComponents.weekOfYear == currentDateComponents.weekOfYear){
                switch (dateComponents.weekday) {
                    case 1:
                        return @"星期日";
                        break;
                    case 2:
                        return @"星期一";
                        break;
                    case 3:
                        return @"星期二";
                        break;
                    case 4:
                        return @"星期三";
                        break;
                    case 5:
                        return @"星期四";
                        break;
                    case 6:
                        return @"星期五";
                        break;
                    case 7:
                        return @"星期六";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if (destDateString.length > 0){
        if ([destDateString isEqualToString:@"今天"]){
            destDateString = @"";
            if (dateComponents.hour<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd:",dateComponents.hour]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd:",dateComponents.hour]];
            }
            if (dateComponents.minute<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd",dateComponents.minute]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd",dateComponents.minute]];
            }
        }
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        destDateString = [dateFormatter stringFromDate:destDate];
    }
    return destDateString;
}
+ (NSString *)calculateTimeWithFaceTimeDayTarget:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * destDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    greCalendar.firstWeekday = 2;
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents *dateComponents = [greCalendar components:unitFlags fromDate:destDate];
    NSDateComponents *currentDateComponents = [greCalendar components:unitFlags fromDate:[NSDate date]];
    NSString * destDateString = nil;
    if (dateComponents.year == currentDateComponents.year && dateComponents.month == currentDateComponents.month && dateComponents.day == currentDateComponents.day){
        destDateString = @"今天";
    }else{
        NSDateComponents * tempDateComponents = [[NSDateComponents alloc] init];
        [tempDateComponents setDay:-1];
        NSDate *newDate = [greCalendar dateByAddingComponents:tempDateComponents toDate:[NSDate date] options:0];
        NSDateComponents *dateComponents1 = [greCalendar components:unitFlags fromDate:newDate];
        if (dateComponents1.year==dateComponents.year && dateComponents1.month==dateComponents.month && dateComponents1.day == dateComponents.day){
            destDateString = @"昨天";
        }
    }
    if (destDateString.length > 0){
        if ([destDateString isEqualToString:@"今天"]||[destDateString isEqualToString:@"昨天"]){
            if ([destDateString isEqualToString:@"今天"]){
                destDateString = @"";
            }
            if (dateComponents.hour<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd:",dateComponents.hour]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd:",dateComponents.hour]];
            }
            if (dateComponents.minute<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd",dateComponents.minute]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd",dateComponents.minute]];
            }
        }
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        destDateString = [dateFormatter stringFromDate:destDate];
    }
    return destDateString;
}

#pragma mark 获取通讯录并上传到服务器
+ (BOOL)getContactsList
{
    NSMutableArray * contactsArray = [NSMutableArray array];
    //定义通讯录名称
    ABAddressBookRef idAddressBook = idAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(idAddressBook, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //如果没获得权限
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return NO;
    }
    //获取通讯录失败
    if (idAddressBook == nil) {
        return NO;
    }
    //获取通讯录数组
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(idAddressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(                          kCFAllocatorDefault,CFArrayGetCount(people),people);
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*)(unsigned long) ABPersonGetSortOrdering()
                      );
    
    NSArray * allPoples = (__bridge NSArray*)peopleMutable;
    if (allPoples.count == 0) {//通讯录没有联系人
        return NO;
    }
    if (contactsArray == nil){
        contactsArray = [NSMutableArray array];
    }else{
        [contactsArray removeAllObjects];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //填装数组
        [allPoples enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(id idPerson, NSUInteger idx, BOOL *stop) {
            //获取姓名
            NSString * firstName = (__bridge  NSString *)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonFirstNameProperty);
            NSString * lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonLastNameProperty);
            NSString * wholeName = @"";
            if ([firstName isEqualToString:@"(null)"]){
                firstName = @"";
            }
            if ([lastName isEqualToString:@"(null)"]){
                lastName = @"";
            }
            if (!lastName&&firstName) {
                wholeName = firstName;
            }else if (lastName&&!firstName){
                wholeName = lastName;
            }else{
                if (firstName != nil && lastName != nil){
                    wholeName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
                }
            }
            //电话
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonPhoneProperty);
            NSMutableString * strPhone = [[NSMutableString alloc] init];
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            {
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                [strPhone appendString:tmpPhoneIndex];
                if (j<ABMultiValueGetCount(tmpPhones)-1) {
                    [strPhone appendString:@","];
                }
            }
            if (strPhone.length > 0){
                NSArray * array = [strPhone componentsSeparatedByString:@","];
                NSMutableArray * muArray = [NSMutableArray arrayWithArray:array];
                [muArray removeObject:@""];
                for (NSString * phoneStr in muArray){
                    if (phoneStr.length >0 && ![phoneStr isEqualToString:@"null"] && ![phoneStr isEqualToString:@"(null)"]){
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        
                        //填装手机号
                        NSString * phone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                        [dict setObject:phone forKey:@"t"];
                        //填装姓名
                        if (wholeName.length > 0  && ![wholeName isEqualToString:@"null"] && ![wholeName isEqualToString:@"(null)"] && ![wholeName isEqualToString:@"(null)(null)"]){
                            [dict setObject:wholeName forKey:@"n"];
                        }else{
                            [dict setObject:phone forKey:@"n"];
                        }
                        [contactsArray addObject:dict];
                    }
                }
            }
            CFRelease(tmpPhones);
        }];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactsArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *httpBodyString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        ATUserModel * user = [ATUserModel currentUser];
//        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",user.uid],@"uid",(httpBodyString==nil?@"":httpBodyString),@"postdata",nil];
//        // 开始请求
//        [IDHttpManager PostRequestWithUrl:[IDInterfaceManager sharedInstance].getUpUserAddressList TimeOut:15 RetryNum:0 PostData:postDict FinishBlock:^(NSData *data) {
//        } FailedBlock:^(NSError *error) {
//            
//            
//        }];
        
    });
    return YES;
}
//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini";
    return platform==nil?@"":platform;
}
//根据秒数返回 时:分:秒
+(NSString *)getTimeStringWithSecond:(NSInteger)second{
    if (second > 0){
        
        NSInteger minuteNum = second/60;
        NSInteger secondNUM = second%60;
        if (minuteNum > 0){
            NSInteger hourNum = minuteNum/60;
            NSString *timeStr = @"";
            if (hourNum > 0){
                minuteNum = minuteNum%60;
                timeStr = [NSString stringWithFormat:@"%zd时",hourNum];
            }
            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%zd分",minuteNum]];
            if (secondNUM > 0){
                timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%zd秒",secondNUM]];
            }
            return timeStr;
        }else{
            return [NSString stringWithFormat:@"%zd秒",secondNUM];
        }
    }else{
        return @"0秒";
    }
}
//检查网络状态
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
//截取view一部分转成image
+ (UIImage *)cutDownScreenView:(UIView *)view rect:(CGRect)rect{
    CGRect rectView = view.bounds;
    rectView.origin.y = rect.origin.y;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [view drawViewHierarchyInRect:rectView afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UILabel *)addLabelWithRect:(CGRect)rect text:(NSString *)text font:(NSInteger)fontSize color:(NSString *)colorStr alignment:(NSTextAlignment)alignment backColor:(NSString *)backColor numbersLine:(NSInteger)number parentView:(UIView *)parentView
{
    if (text == nil || [text isKindOfClass:[NSNull class]] || [text isEqualToString:@"null"] || [text isEqualToString:@"(null)"]){
        text = @"";
    }
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    [label setText:text];
    if (fontSize > 0){
        [label setFont:[UIFont systemFontOfSize:fontSize]];
    }
    if (backColor.length == 0) {
        label.backgroundColor = [UIColor clearColor];
    }else{
        [label setBackgroundColor:[[self class]  colorWithHexString:backColor]];
    }
    if (colorStr.length == 0) {
        [label setTextColor:[UIColor blackColor]];
    }else{
        [label setTextColor:[[self class] colorWithHexString:colorStr]];
    }
    [label setTextAlignment:alignment];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    label.numberOfLines = number;
    if(parentView){
        [parentView addSubview:label];
    }
    return label;
}
//画虚线
+ (UIImageView *)drawDashLineWithRect:(CGRect)rect WithColor:(UIColor *)color parentView:(UIView *)parentView
{
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:rect];
    if (parentView){
        [parentView addSubview:lineView];
    }
    UIGraphicsBeginImageContext(lineView.frame.size);   //开始画线
    [lineView.image drawInRect:CGRectMake(0, 0, lineView.frame.size.width, lineView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {5,2};   //虚线宽度，间距
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line,color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);   //画虚线
    CGContextMoveToPoint(line, 0, LINE_HEIGHT);    //开始画线
    CGContextAddLineToPoint(line, rect.size.width, LINE_HEIGHT);
    CGContextStrokePath(line);
    lineView.image = UIGraphicsGetImageFromCurrentImageContext();
    return lineView;
}
+(NSArray *)checkHasOwnApp{
    NSArray *mapSchemeArr = @[@"baidumap://map/",@"qqmap://map/"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果地图", nil];
    
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]])
        {
            if (i == 0) {
                [appListArr addObject:@"百度地图"];
            } else {
                [appListArr addObject:@"腾讯地图"];
                
            }
            
        }
    }
    
    
    return appListArr;
}
//把时间转化成当前时间时分秒形式
+(NSString *)fixStringForDateHms:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}


//把时间转化成当前时间年月日形式
+ (NSString *)fixStringForDateYmd:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
}
//把时间转化成年月日时分形式
+ (NSString *)fixStringForDateyMdHm:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    // [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
}

//获取当前系统的yyyy-MM-dd格式时间(年月日)
+(NSString *)getTime
{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

+(NSString *)getSizeStringWithString:(NSString *)oldString{
    
    long long oldSize=[oldString longLongValue];
    
    CGFloat size=0.0;
    NSString *newString=nil;
    if (oldSize>=1024) {
        if (oldSize>=1024*1024) {
            size=(float)oldSize/(1024*1024);
            newString=[NSString stringWithFormat:@"%.2fM",size];
        }
        else{
            size=(float)oldSize/1024;
            newString=[NSString stringWithFormat:@"%.2fKB",size];
        }
    }
    else{
        newString=[NSString stringWithFormat:@"%@B",oldString];
    }
    
    return newString;
}

+(NSString *)getXingzuo:(NSDate *)in_date
{
    //计算星座
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:in_date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:in_date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}
//获取生肖
+(NSString *)getChineseZodiac:(NSDate *)date;
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy"];
    NSString *string = [dateFormat stringFromDate:date];
    int  year= [string  intValue];
    int i=year%12;
    NSArray * arr  = [NSArray arrayWithObjects:@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",nil];
    
    return arr[i];
}
//错误提示展示
+ (void)IDHUDShowFailCustomViewState:(UIView *)parentView
                           WithTitle:(NSString *)title
                               delay:(NSTimeInterval)delay
                            animaton:(BOOL)animation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([parentView viewWithTag:199771]){
            UIView * view = [parentView viewWithTag:199771];
            [[view class] cancelPreviousPerformRequestsWithTarget:view];
            [view removeFromSuperview];
        }
        MBProgressHUD * newStateHud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)parentView];
        [parentView addSubview:newStateHud];
        newStateHud.tag = 199771;
        newStateHud.removeFromSuperViewOnHide = YES;
        newStateHud.mode = MBProgressHUDModeCustomView;
        newStateHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD_failed"]];
        newStateHud.customView.frame=CGRectMake(newStateHud.customView.frame.origin.x, newStateHud.customView.frame.origin.y, 40, 40);
        
        newStateHud.detailsLabelText=title;
        newStateHud.detailsLabelFont = [UIFont systemFontOfSize:16.];
        
        [newStateHud show:animation];
        
        [newStateHud hide:animation afterDelay:delay];
    });
}
//替换特殊字符
+(NSString *)getReplaceXMLCharacter:(NSString *)chaString{
    chaString = [chaString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    chaString = [chaString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    chaString = [chaString stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    chaString = [chaString stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    chaString = [chaString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    return chaString;
}
//根据imageSize裁剪image
+ (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage size:(CGSize)imageSize {
    UIImage *thumbnail = nil;
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        CGSize itemSize = CGSizeMake(imageSize.width, imageSize.height);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}
//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
//剪切图片(从中心算起）
+ (UIImage *)getCutImageSize:(CGSize)size originalImage:(UIImage *)originalImage{
    originalImage = [self fixOrientation:originalImage];
    CGRect rect = [self getCutRectWithBigSize:originalImage.size cutSize:size];
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, cutImageRef);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(cutImageRef);
    
    return cutImage;
}

//获取截图区域(从中心算起）
+ (CGRect)getCutRectWithBigSize:(CGSize)bigSize cutSize:(CGSize)cutSize{
    CGFloat scale = [self getCompressScaleWithBigSize:bigSize smallSize:cutSize];
    CGPoint bigPoint = CGPointMake(bigSize.width / 2.0f, bigSize.height / 2.0f);
    CGSize scaleSize = CGSizeMake(cutSize.width / scale, cutSize.height / scale);
    CGRect Rect = CGRectMake(bigPoint.x - scaleSize.width / 2.0f, bigPoint.y - scaleSize.height / 2.0f, scaleSize.width, scaleSize.height);
    return Rect;
}
+ (CGFloat)getCompressScaleWithBigSize:(CGSize)bigSize smallSize:(CGSize)smallSize{
    CGFloat scale;
    if (bigSize.height / bigSize.width >= smallSize.height / smallSize.width) {
        scale = smallSize.width / bigSize.width;
    }else{
        scale = smallSize.height / bigSize.height;
    }
    return scale;
}
//解决剪切后图片旋转了的问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
