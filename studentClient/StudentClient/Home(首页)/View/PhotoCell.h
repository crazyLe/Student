//
//  PhotoCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoCell;

@protocol PhotoCellDelegate <NSObject>

-(void)photoCell:(PhotoCell *)cell didClickBtnWithUrl:(NSString *)url;

@end

@interface PhotoCell : UITableViewCell

@property (nonatomic, assign)CGFloat  cellHeight;
@property(nonatomic,strong)NSMutableArray * photoArray;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn3;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn4;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn5;
@property(nonatomic,weak)id<PhotoCellDelegate> delegate;

@end
