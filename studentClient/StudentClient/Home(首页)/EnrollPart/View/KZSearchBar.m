//
//  KZSearchBar.m
//  学员端
//
//  Created by gaobin on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//  http://www.ithao123.cn/content-10690260.html

#import "KZSearchBar.h"
#import "UIImage+HJ.h"

@implementation KZSearchBar

+ (instancetype)searchBar {
    
    return [[self alloc] init];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#c8c8c8"];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入驾校或班型名称" attributes:dic];
        
        
        //设置萌萌哒的放大镜
        UIImageView * magnifierImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-fangdajing"]];
        self.leftView = magnifierImgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        
    }
    
    return self;
}

//设置自定义搜索框leftView的位置坐标
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
     // 设置左侧图片的frame
    self.leftView.frame = CGRectMake(18, 17, 15, 15);
   
    
}
#pragma mark -- 重写占位符的x值,默认从leftView的左侧开始
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    
    //光标的偏移量是根据leftView的算的，占位符的偏移量是根据光标的位置算的。所以设置占位符偏移量为1是最合适的。
    placeholderRect.origin.x += 1;
    
    return placeholderRect;
    
}
#pragma mark -- 重写文字输入时的X值
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect editingRect = [super editingRectForBounds:bounds];
    
    editingRect.origin.x += 15 +10;
    
    return editingRect;
}

#pragma mark -- 重写文字显示时的X值
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super editingRectForBounds:bounds];
    
    textRect.origin.x += 15+ 10;
    
    return textRect;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
