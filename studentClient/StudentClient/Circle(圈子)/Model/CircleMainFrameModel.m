//
//  CircleMainFrameModel.m
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CircleMainFrameModel.h"

@implementation CircleMainFrameModel
{
    CGFloat leftPadding;
    CGFloat rightPadding;
    
}


-(void)setCircleMainModel:(CircleMainModel *)circleMainModel
{
    _circleMainModel = circleMainModel;
    
    self.iconImageViewF = CGRectMake(10, 14, 33, 33);
    
    //赋值间距常量
    leftPadding = CGRectGetMaxX(self.iconImageViewF)+10;
    rightPadding = 30;
    
    CGSize nameSize = [circleMainModel.nickName sizeWithFont:kFont14 maxSize:CGSizeMake(kScreenWidth-leftPadding-rightPadding-20, kFont14.lineHeight)];
    
    self.nameLabelF = CGRectMake(leftPadding, 14, nameSize.width, 25);
    
    self.vipImageViewF = CGRectMake(CGRectGetMaxX(self.nameLabelF)+5, 18, 15, 15);
    self.topBestImageViewF = CGRectMake(kScreenWidth-30, 0, 20, 25);
    /*
    CGSize contentSize = [circleMainModel.content sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kScreenWidth-leftPadding-rightPadding, MAXFLOAT)];
     */
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc]initWithString:circleMainModel.content];
    [temp addAttribute:NSFontAttributeName value:kFont15 range:NSMakeRange(0, temp.length)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth-leftPadding-rightPadding, MAXFLOAT) text:temp];
    self.contentLabelF = CGRectMake(leftPadding, CGRectGetMaxY(self.nameLabelF)+4, layout.textBoundingSize.width, layout.textBoundingSize.height);
    
    if (circleMainModel.pic.count>0) {//有图片
        
        CGFloat imageW = 88;
        CGFloat imageH = imageW;
        CGFloat imagePadding = 1.5;
        for (int i = 0; i<circleMainModel.pic.count; i++) {
            int row = i/2;
            int col = i%2;
            CGRect rect = CGRectMake(leftPadding + (imageW+imagePadding)*col, CGRectGetMaxY(self.contentLabelF)+8+(imageH+imagePadding)*row, imageW, imageH);
            NSString *imageRectStr = NSStringFromCGRect(rect);
            [self.imageViewFrameArray addObject:imageRectStr];
        }
        //计算其他控件frame
        [self calucateOtherFrameWithHaveImage:YES];
        
    }
    else//没有图片
    {
        //计算其他控件frame
        [self calucateOtherFrameWithHaveImage:NO];

    }

}
-(void)calucateOtherFrameWithHaveImage:(BOOL)haveImage
{

    if (haveImage) {//有图片
        
        NSString *lastImageRectStr = self.imageViewFrameArray.lastObject;
        
        CGFloat maxY = CGRectGetMaxY(CGRectFromString(lastImageRectStr));
        
        [self getOtherFrameWithTopMaxY:maxY];
    
    }
    else//无图片
    {
        CGFloat maxY = CGRectGetMaxY(self.contentLabelF);
        
        [self getOtherFrameWithTopMaxY:maxY];

    }

}
-(void)getOtherFrameWithTopMaxY:(CGFloat)maxY
{
    CGFloat commentBtnW = autoScaleW(60);
    CGFloat commentBtnH = 20;
    CGFloat zanBtnH = commentBtnH;
    CGFloat zanBtnW = commentBtnW;
    
    CGFloat perfectCommentImageW = 50;
    CGFloat perfectCommentImageH = 35;

    CGSize timeSize = [_circleMainModel.addtime sizeWithFont:kFont11 maxSize:CGSizeMake(110, kFont11.lineHeight)];
    
    self.timeLabelF = CGRectMake(leftPadding, maxY+12, timeSize.width, timeSize.height);
    
    CGSize locationSize = [_circleMainModel.area sizeWithFont:kFont11 maxSize:CGSizeMake(kScreenWidth-leftPadding-110-commentBtnW-zanBtnW, kFont11.lineHeight)];
    
    self.locationLabelF = CGRectMake(CGRectGetMaxX(self.timeLabelF)+15, CGRectGetMinY(self.timeLabelF), locationSize.width, locationSize.height);
    
    self.commentBtnF = CGRectMake(kScreenWidth-commentBtnW-zanBtnW,  CGRectGetMinY(self.timeLabelF)-3, commentBtnW, commentBtnH);
    self.zanBtnF = CGRectMake(kScreenWidth-zanBtnW,  CGRectGetMinY(self.timeLabelF)-3, zanBtnW, zanBtnH);
    if (_circleMainModel.comemnt.addtime != nil) {//有神评
        
        CircleCommentModel *commentModel = _circleMainModel.comemnt;
        self.lineViewF = CGRectMake(0, CGRectGetMaxY(self.timeLabelF)+12, kScreenWidth, LINE_HEIGHT);
        self.commentIconImageViewF = CGRectMake(leftPadding, CGRectGetMaxY(self.lineViewF)+15,33, 33);
        
        CGSize commentNameSize = [commentModel.nickname sizeWithFont:kFont14 maxSize:CGSizeMake(kScreenWidth-leftPadding-33-10-commentBtnW-perfectCommentImageW, kFont14.lineHeight)];
        
        
        self.commentNameLabelF = CGRectMake(CGRectGetMaxX(self.commentIconImageViewF)+10, CGRectGetMaxY(self.lineViewF)+18, commentNameSize.width, commentNameSize.height);
        
        CGSize commentTimeSize = [commentModel.addtime sizeWithFont:kFont11 maxSize:CGSizeMake(kScreenWidth-leftPadding-33-10-rightPadding, kFont11.lineHeight)];
        
        self.commentTimeLabelF = CGRectMake(CGRectGetMaxX(self.commentIconImageViewF)+10, CGRectGetMaxY(self.commentNameLabelF)+4, commentTimeSize.width, commentTimeSize.height);
        
        self.perfectCommentImageViewF = CGRectMake(kScreenWidth-zanBtnW-10-perfectCommentImageW, CGRectGetMaxY(self.lineViewF)+10, perfectCommentImageW, perfectCommentImageH);
        self.commentZanBtnF = CGRectMake(kScreenWidth-zanBtnW,  CGRectGetMaxY(self.lineViewF)+perfectCommentImageH/2+10-zanBtnH/2, zanBtnW, zanBtnH);
        /*
        CGSize commentContentSize = [commentModel.content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kScreenWidth-CGRectGetMaxX(self.commentIconImageViewF)-10-8, MAXFLOAT)];
         */
        NSMutableAttributedString *temp = [[NSMutableAttributedString alloc]initWithString:commentModel.content];
        [temp addAttribute:NSFontAttributeName value:kFont15 range:NSMakeRange(0, temp.length)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth-CGRectGetMaxX(self.commentIconImageViewF)-10-8, MAXFLOAT) text:temp];
        self.commentContentLabelF = CGRectMake(CGRectGetMaxX(self.commentIconImageViewF)+10, CGRectGetMaxY(self.commentTimeLabelF)+4, layout.textBoundingSize.width, layout.textBoundingSize.height);
        
        self.perfectCommentViewF = CGRectMake(0, CGRectGetMaxY(self.lineViewF), kScreenWidth, CGRectGetMaxY(self.commentContentLabelF)-CGRectGetMaxY(self.lineViewF)+20);
        
        self.cellHeight = CGRectGetMaxY(self.perfectCommentViewF);
        
        
        
        
    }
    else//无神评
    {
        self.cellHeight = CGRectGetMaxY(self.timeLabelF)+12;
        
    }
    
}
-(NSMutableArray *)imageViewFrameArray
{
    if (_imageViewFrameArray == nil) {
        _imageViewFrameArray = [[NSMutableArray alloc]init];
    }
    return _imageViewFrameArray;
    
}

@end
