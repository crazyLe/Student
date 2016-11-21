//
//  AddressManager.h
//  学员端
//
//  Created by zuweizhong  on 16/8/6.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject

singletonInterface(AddressManager)

-(void)updateAddressInfo;

@property(nonatomic,strong)NSMutableArray * addressArray;


@end
