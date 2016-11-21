//
//  ExamQuestionTopCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamQuestionTopCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#define FORCE_RECOPY NO

@implementation ExamQuestionTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        YYLabel *contentLabel = [[YYLabel alloc]init];
        
        self.contentLabel = contentLabel;
                
        self.contentLabel.font = [UIFont systemFontOfSize:17];
        
        self.contentLabel.numberOfLines = 0;
                
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
-(void)setQuestionModel:(ExamQuestionModel *)questionModel {
    _questionModel = questionModel;
    
    [self.contentImageView removeFromSuperview];
    
    [self.playerView removeFromSuperview];
    
    CGSize size = CGSizeMake(kScreenWidth-16, CGFLOAT_MAX);
    
    //text 与 UIView混排
    NSMutableAttributedString *textImage = [NSMutableAttributedString new];
    
    [textImage appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:nil]];
    
    UIButton *btn = [[UIButton alloc]init];
    
    self.multi_radioBtn = btn;
    
    [btn setTitle:@"单选" forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(0, 0,37, 15);
    
    btn.userInteractionEnabled = NO;
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"科一做题_更多"] forState:UIControlStateNormal];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:btn contentMode:UIViewContentModeTop attachmentSize:btn.frame.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentTop];
    
    [textImage appendAttributedString:attachText];
    
    NSMutableAttributedString *conentText = [NSMutableAttributedString new];
    
    NSDictionary *attris = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]};
    
    [conentText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.contentLabel.text] attributes:attris]];
    
    [textImage appendAttributedString:conentText];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:textImage];
    
    self.contentLabel.attributedText = textImage;
    
    self.contentLabel.frame = CGRectMake(8, 21, layout.textBoundingSize.width, layout.textBoundingSize.height);
    
    
    if (self.questionModel.is_img == 1) {//有图片
        //TODU
        NSData *data = self.questionModel.image_bin;
        
        if (self.questionModel.media_type == 2) {//播放动画
            
            [self copyDataToFileIfNeededWithQuestionId:self.questionModel.idNum data:data];
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *destinationPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4",self.questionModel.idNum]];
            
            [self.playerView pause];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            
            self.playerView = [[ZFPlayerView alloc]init];
            self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
            self.playerView.frame = CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+10, kScreenWidth-16, 150);
            [self.contentView addSubview:self.playerView];
            
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
            playerModel.videoURL = [NSURL fileURLWithPath:destinationPath];
            // Set ZFPlayerModel
            self.playerView.playerModel = playerModel;
            [self.playerView autoPlayTheVideo];
            
            self.cellHeight = CGRectGetMaxY(self.playerView.frame)+21;
        }
        else//播放图片
        {
        
            UIImage *image = [UIImage imageWithData:data];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            self.contentImageView = imageView;
            
            self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            self.contentImageView.frame = CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+10, kScreenWidth-16, 150);
            
            [self.contentView addSubview:imageView];
            
            self.cellHeight = CGRectGetMaxY(self.contentImageView.frame)+21;
        }
    } else {
        self.cellHeight = CGRectGetMaxY(self.contentLabel.frame)+21;
    }
}
    
- (void)moviePlayDidEnd:(NSNotification *)notification {
    if (self.playerView) {
        if (self.playerView.playerModel) {
            [self.playerView pause];
            self.playerView.playerModel.seekTime = 0;
            [self.playerView resetToPlayNewVideo:self.playerView.playerModel];
        }
    }
}
    
- (void)copyDataToFileIfNeededWithQuestionId:(int)idNum data:(NSData *)data
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4",idNum]];
    HJLog(@"%@",destinationPath);
    __block NSData * blockData = data;
    void (^copyDb)(void) = ^(void){
        
        BOOL result = [blockData writeToFile:destinationPath atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
        if (result) {
            NSLog(@"写入成功");
        }
        else
        {
            NSLog(@"写入失败");
        }
    };
    if( FORCE_RECOPY && [fm fileExistsAtPath:destinationPath] ) {
        [fm removeItemAtPath:destinationPath error:NULL];
        copyDb();
    }
    else if( ![fm fileExistsAtPath:destinationPath] ) {
        HJLog(@"INFO | db file needs copying");
        copyDb();
    }
}


@end
