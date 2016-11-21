//
//  UploadPhotoCell.m
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "UploadPhotoCell.h"

@implementation UploadPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)uploadBtnClick {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
    
    [actionSheet showInView:self];
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        //从相册中选取
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [_delegate presentViewController:imagePicker animated:YES completion:nil];
        
        
    }if (buttonIndex == 1) {
        
        //拍照
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [_delegate presentViewController:imagePicker animated:YES completion:nil];
        
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [_uploadBtn setImage:image forState:UIControlStateNormal];
    if ([self.uploadDelegate respondsToSelector:@selector(uploadPhotoCell:didSelectImageWithImage:)]) {
        [self.uploadDelegate uploadPhotoCell:self didSelectImageWithImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
