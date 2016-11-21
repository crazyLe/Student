//
//  SubjectExamPopView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectExamPopView.h"
@interface SubjectExamPopView ()

@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)NSMutableArray * itemRowViewArray;
@property(nonatomic,strong)PopItemRowView * currentRowView;


@end

@implementation SubjectExamPopView
/**
 *  代码创建
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if (self = [super init]) {
        
        [self setupSubviews];
        
    }
    
    return self;
    
}
/**
 *  XIB创建
 *
 *  @param aDecoder aDecoder
 *
 *  @return instancetype
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupSubviews];
        
    }
    return self;
}

-(void)setupSubviews
{
    
    
    self.itemRowViewArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]init];
    
    self.bgView = bgView;
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    bgView.layer.shadowOpacity = 0.5;

    bgView.layer.shadowOffset = CGSizeMake(0, 15);

    bgView.layer.shadowRadius = 5;
    
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]init];
    
    self.contentView = contentView;
  
    self.contentView.layer.cornerRadius = 5.0f;
    
    self.contentView.clipsToBounds = YES;
    
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    
    
    
 

}
-(void)setClassTypeTitleArray:(NSMutableArray *)classTypeTitleArray
{
    _classTypeTitleArray = classTypeTitleArray;
    
    for (int i = 0; i<self.classTypeTitleArray.count; i++) {
        
        PopItemRowView *rowView = [[[NSBundle mainBundle] loadNibNamed:@"PopItemRowView" owner:nil options:nil] lastObject];
        [rowView.titleNumBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        rowView.title.text = self.classTypeTitleArray[i];
        [rowView addTarget:self action:@selector(rowClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:rowView];
        
        [self.itemRowViewArray addObject:rowView];

    }
    


}
-(void)setClassTypeNumArray:(NSMutableArray *)classTypeNumArray
{
    _classTypeNumArray = classTypeNumArray;
    for (int i = 0; i<self.itemRowViewArray.count; i++) {
        
        PopItemRowView *rowView = self.itemRowViewArray[i];
        
        rowView.classTypeNumArray = self.classTypeNumArray[i];
        
        rowView.numExamLabel.text =[NSString stringWithFormat:@"%ld",((NSMutableArray *)self.classTypeNumArray[i]).count];

        
    }

}
-(void)rowClick:(PopItemRowView *)rowView
{
    self.currentRowView.selected = NO;
    
    rowView.selected = YES;
    
    self.currentRowView = rowView;
    
    if (self.clickItemBlock) {
    
        self.clickItemBlock(rowView,rowView.classTypeNumArray);
    }
    


    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.contentView.frame = CGRectMake(6, 0, self.width-12, self.height-20);

    self.bgView.frame = CGRectMake(8, 2, self.width-16, self.height-24);

    CGFloat itemWidth = (self.width-12)/2;
    
    CGFloat itemHeight = 45;
    
    for (int i = 0; i<self.itemRowViewArray.count; i++) {
        
        PopItemRowView *rowView = self.itemRowViewArray[i];
        
        int row = i%7;
        
        int col = i/7;
        
        rowView.frame = CGRectMake(itemWidth*col, row*itemHeight, itemWidth, itemHeight);
  
    }


}
-(void)showWithCompletionBlock:(ShowCompletionBlock)block
{
    [self.contentController.view addSubview:self];
    
    block();
}
-(void)dismissWithDismissCompletionBlock:(DismissCompletionBlock)block
{
    [self removeFromSuperview];
    
    block();

}

@end
