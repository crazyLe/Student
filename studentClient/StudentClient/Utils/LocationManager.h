//
//  LocationManager.h
//  Finance
//
//  Created by zwz on 15/12/30.
//  Copyright © 2015年 hqwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^LocationFinishBlock)(CGFloat longitude,CGFloat latitude,NSString *locationString,NSDictionary *addressDictionary,CLPlacemark *placeMark);

@interface LocationManager : NSObject

singletonInterface(LocationManager)

-(void)startLocationWithFinishSuccessBlock:(LocationFinishBlock)finishBlock;

-(void)stopLocation;
/**
 * 经度
 */
@property(nonatomic,assign)CGFloat longitude;

/**
 *  纬度
 */
@property(nonatomic,assign)CGFloat latitude;
/**
 *  地理位置
 */
@property(nonatomic,copy)NSString *locationString;
/**
 *  位置信息字典
 */
@property(nonatomic,strong)NSDictionary * addressDictionary;
/**
 *  位置信息
 */
@property(nonatomic,strong)CLPlacemark * placeMark;


@end
