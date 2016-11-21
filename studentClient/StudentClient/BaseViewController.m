//
//  BaseViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    //适配ios 7，使得在ios7上滚动视图不会上移64
//    [self setRectEdgeNone];
 
}

- (void)setRectEdgeNone {
    
    

    if (IOS7_OR_LATER) {
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    else
    {
    
        float barHeight = 0;
        
        if (!IS_IPAD && ![[UIApplication sharedApplication] isStatusBarHidden]) {
            
            barHeight += ([[UIApplication sharedApplication]statusBarFrame]).size.height;
            
        }
        
        if(self.navigationController && !self.navigationController.navigationBarHidden) {
            
            barHeight += self.navigationController.navigationBar.frame.size.height;
            
        }
        
        for (UIView *view in self.view.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height - barHeight);
            }
            else
            {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height);
            }
            
        }

    }

}

@end
