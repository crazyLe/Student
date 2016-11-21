//
//  UIFont+AutoScale.h
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  iOS不同机型,文字大小按比例显示runtime实现（只实用于代码字体适配,不实用于XIB）
 */
@interface UIFont (AutoScale)

@end

/**
 *  iOS不同机型,XIB控件文字大小按比例显示runtime实现
 * （实用于XIB创建的控件字体适配，如果有其他自定义的控件需要适配字体请写在此处）
 */

/**
 *  按钮
 */
@interface UIButton (myFont)

@end

/**
 *  Label
 */
@interface UILabel (myFont)

@end
/**
 *  YYLabel
 */
@interface YYLabel (myFont)

@end
