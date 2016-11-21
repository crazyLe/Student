//
//  UIViewController+NavigationController.m
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import "UIViewController+NavigationController.h"
#import "LocationButton.h"
#import "NavCenterButton.h"
@implementation UIViewController (NavigationController)

+(void)load
{
    //兼容ios 7（ios 7 默认 Translucent 为YES）
    if( IOS_VERSION_8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    //导航栏背景图全局设置
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#353c3f"]];
    // 设置导航默认标题的颜色及字体大小
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:18]};

}
-(UIButton *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)selector andCenterTitle:(NSString *)title
{
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
         [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }

    [leftBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    
    
    return leftBtn;

}
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector
{
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    //rightBtn.frame = CGRectMake(0, 10, 23, 20);
    rightBtn.frame = CGRectMake(0, 10, 20, 20);
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;

}
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle
{

    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 5, 28, 20);
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;

    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;


}
//右侧按钮为X色
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle rightColor:(UIColor *)color {
    
    
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 5, 100, 25);
    //首先要设置按钮上控件(label)的位置,再去设置label的位置
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;

    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;
}

-(NSArray *)createMainNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector
{

    //创建左边的按钮
    LocationButton *leftBtn = [[LocationButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 65, 20);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:[USER_DEFAULT objectForKey:@"locationCity"] forState:UIControlStateNormal];
    if (leftName) {
        [leftBtn setImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 10, 20, 20);
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;

}
-(NSArray *)createRightLocationNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector {
    
    //左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0, 10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    //设置title
    self.navigationItem.title = title;
 
    //创建右边的按钮
    LocationButton *rightBtn = [[LocationButton alloc]init];
    rightBtn.frame = CGRectMake(0,10, 60, 20);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    NSString *currentCitys = [USER_DEFAULT objectForKey:@"locationCity"];
    [rightBtn setTitle:currentCitys forState:UIControlStateNormal];
    if (rightName) {
        [rightBtn setImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        
        [rightBtn setImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    NSArray *arr = @[leftBtn,rightBtn];

    return arr;
    
    
}
//导航中间带按钮
-(NSArray *)createCenterBtnNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title  centerBtnSelector:(SEL)centerSelector andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle
{
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    
    NavCenterButton *navCenterBtn = [[NavCenterButton alloc]init];
    
    [navCenterBtn setImage:[UIImage imageNamed:@"centerNavBtn"] forState:UIControlStateNormal];
    [navCenterBtn setTitle:title forState:UIControlStateNormal];
    
    navCenterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [navCenterBtn setTitleColor:[UIColor colorWithHexString:@"#fffffd"] forState:UIControlStateNormal];
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(MAXFLOAT, 20)];
    
    navCenterBtn.frame = CGRectMake((kScreenWidth-size.width*((float)4/3))/2, 10, size.width*((float)4/3), 20);
    
    [navCenterBtn addTarget:self action:centerSelector forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = navCenterBtn;

    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 10, 20, 20);
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;

}


@end



@implementation UIViewController(Translucent)

+(void)load
{
    [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(my_viewDidLoad)];

}
-(void)my_viewDidLoad
{
   
    //设置每一个控制器的translucent为NO，导航栏不透明，适配ios7（ios 7默认透明为YES，会导致view上移64）
    self.navigationController.navigationBar.translucent = NO;
    
    [self my_viewDidLoad];
}



@end
