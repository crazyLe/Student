//
//  WithdrawViewController.m
//  学员端
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CLAlertView.h"

#define CLCUSTOMSCREEN_FRAME [UIScreen mainScreen].bounds
#define CLCUSTOMSCREEN_SIZE [UIScreen mainScreen].bounds.size

#define CLCUSTOMSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define CLCUSTOMSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



@interface CLAlertView ()

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) NSString *defaultBtn;

@property (nonatomic ,strong) NSString *cancelBtn;


@property (nonatomic ,strong) NSString *text;


@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) UIButton *cancelButton;


@end



@implementation CLAlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CLCUSTOMSCREEN_FRAME];
    if (self) {
        
        
        [self setupUI];

    }
    return self;
}

- (instancetype)initWithAlertViewWithTitle:(NSString *)title text:(NSString *)text DefauleBtn:(NSString *)defaultBtn cancelBtn:(NSString *)cancelBtn defaultBtnBlock:(defaultBtnClicked)defaultBlock cancelBtnBlock:(cancelBtnClicked)cancelBlock
{
    self = [super init];
    if (self) {
        
        self.title = title;
        self.text = text;
        self.defaultBtn = defaultBtn;
        self.cancelBtn = cancelBtn;
        self.cancelBtnBlock = cancelBlock;
        self.defaultBtnBlock = defaultBlock;
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CLCUSTOMSCREEN_FRAME;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.1;
    [self addSubview:bgView];
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:view];
    view.center = self.center;
    view.backgroundColor = [UIColor whiteColor];
    
    view.frame = CGRectMake(self.frame.size.width/2.0 , -10, 240.0/320*CLCUSTOMSCREEN_WIDTH, 10);
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    self.contentView = view;

}

- (void)alertViewWithTitle:(NSString *)title text:(NSString *)text DefauleBtn:(NSString *)defaultBtn cancelBtn:(NSString *)cancelBtn {
    

    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.contentView.frame.size.width - 20, 20)];
    label.font = [UIFont boldSystemFontOfSize:19];
    [self.contentView addSubview:label];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
  
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    textLabel.text = text;
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textAlignment = NSTextAlignmentCenter;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 40, 400) lineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByCharWrapping];
    
    
    if (size.height > 50 && size.height <= 200) {
         textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, size.height);
    } else if (size.height <= 50){
        
       textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, 50);
    } else {
        
         textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, 200);
        
    }
   
    
    
    [self.contentView addSubview:textLabel];
    
    //线条
    UIView *Hview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame)+8, self.contentView.frame.size.width, LINE_HEIGHT)];
    Hview.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self.contentView addSubview:Hview];
    
    UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:defaultButton];
    //defaultButton.frame = CGRectMake(10, CGRectGetMaxY(Hview.frame), (self.contentView.frame.size.width - 20)/2.0, 44);
    defaultButton.frame = CGRectMake(10, CGRectGetMaxY(Hview.frame), self.contentView.frame.size.width - 20, 44);

    [defaultButton setTitle:cancelBtn forState:UIControlStateNormal];
    
    [defaultButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    defaultButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [defaultButton setTitleColor:[UIColor colorWithHexString:@"5eb5fd"] forState:UIControlStateNormal];
    
    
    
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.contentView addSubview:cancelButton];
//    cancelButton.frame = CGRectMake(CGRectGetMaxX(defaultButton.frame), CGRectGetMaxY(Hview.frame), (self.contentView.frame.size.width - 20)/2.0, 44);
//    [cancelButton setTitle:defaultBtn forState:UIControlStateNormal];
//    
//    UIView *Vview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(defaultButton.frame)-0.5, CGRectGetMaxY(textLabel.frame)+8, 1, 44)];
//    Vview.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
//    [self.contentView addSubview:Vview];
//    
//    [cancelButton addTarget:self action:@selector(defaultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.cancelButton = cancelButton;
    
    
    self.contentView.frame = CGRectMake(self.center.x - 120.0/320*CLCUSTOMSCREEN_WIDTH , self.center.y - CGRectGetMaxY(defaultButton.frame)/2.0, 240.0/320*CLCUSTOMSCREEN_WIDTH, CGRectGetMaxY(defaultButton.frame));
    self.alpha = 0;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
        
  

  
}

- (void)cancelButtonClicked:(UIButton *)sender {

    if (_cancelBtnBlock) {
        _cancelBtnBlock(sender);
    }
    
     [self remove];
    
}


- (void)defaultBtnClicked:(UIButton *)sender {

    if (_defaultBtnBlock) {
        _defaultBtnBlock(sender);
    }
    
    [self remove];
}


- (void)remove {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
   
    
}

- (void)show {
    
    [self alertViewWithTitle:self.title text:self.text DefauleBtn:self.defaultBtn cancelBtn:self.cancelBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self.superview addSubview:self];
    
}




@end
