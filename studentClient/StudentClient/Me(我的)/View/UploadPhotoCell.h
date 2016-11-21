//
//  UploadPhotoCell.h
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameAuthenticationVC.h"
@class UploadPhotoCell;
@protocol UploadPhotoCellDelegate <NSObject>


-(void)uploadPhotoCell:(UploadPhotoCell *)cell didSelectImageWithImage:(UIImage *)image;

@end

@interface UploadPhotoCell : UITableViewCell<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (weak, nonatomic) RealNameAuthenticationVC * delegate;

@property(nonatomic,weak)id<UploadPhotoCellDelegate> uploadDelegate;


@end
