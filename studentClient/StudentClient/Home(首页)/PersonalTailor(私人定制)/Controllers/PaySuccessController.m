//
//  PaySuccessController.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PaySuccessController.h"
#import "QRCodeGenerator.h"
static NSInteger _addHeight = 0;
@interface PaySuccessController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView * lineImageView;

@property(nonatomic,strong)UIView * backView;
/**
 *  私人定制
 */
@property(nonatomic,strong)NSString * introStr0;
@property(nonatomic,strong)NSString * introStr1;
/**
 *  其他订单类型
 */
@property(nonatomic,strong)NSString * introStr;

@property(nonatomic,strong)NSString * nameStr;

@property(nonatomic,strong)NSString * mobileStr;

@property(nonatomic,strong)NSString * addressStr;


@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_type isEqualToString:@"1"]) {//私人订制界面进来,("工作日：私人定制学车秘书将在30分钟内与您取得联系，请您保持手机畅通<br/>非工作日：学车秘书将顺延至工作日与您取得联系)
        NSArray *strArr = [self.resultDict[@"remark"] componentsSeparatedByString:@"<br/>"];

        _addHeight = 45;
        if (strArr.count >=2)
        {
            self.introStr0 = strArr[0];
            self.introStr1 = strArr[1];
        }
    }
    else//普通
    {
        _addHeight = 0;

        NSArray *strArr = [self.resultDict[@"remark"] componentsSeparatedByString:@"<br/>"];
        if (strArr.count >=4)
        {
            self.introStr = strArr[0];
            self.nameStr = strArr[1];
            self.mobileStr = strArr[2];
            self.addressStr = strArr[3];
        }

    }
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"支付结果"];
    [self createUI];
}

- (void)createUI
{
    UIScrollView * backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backScrollView.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    backScrollView.delegate = self;
    backScrollView.showsVerticalScrollIndicator =  NO;
    backScrollView.contentSize = CGSizeMake(kScreenWidth, 667);
    [self.view addSubview:backScrollView];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 477+_addHeight)];
    _backView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:_backView];
    
    UIImageView * markImageV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-48-11-146)/2, 68, 48, 48)];
    markImageV.image = [UIImage imageNamed:@"iconfont-zhifuchenggong"];
    [_backView addSubview:markImageV];
    
    UILabel * remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markImageV.frame)+11, CGRectGetMinY(markImageV.frame), kScreenWidth-CGRectGetMaxX(markImageV.frame)-11-4, 53)];
    NSMutableAttributedString * remindStr = nil;
    remindStr = [[NSMutableAttributedString alloc]initWithString:@"恭喜您,支付成功" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    [remindStr  appendAttributedString:[[NSAttributedString  alloc] initWithString:@"\n\n"attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:3]}]];
    [remindStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单编号：%lld",self.orderId] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    remindLabel.attributedText = remindStr;
    remindLabel.numberOfLines = 0;
    [_backView addSubview:remindLabel];

    UIImageView * codeImageV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-180)/2, CGRectGetMaxY(markImageV.frame)+23, 180, 180)];
    NSURL *url = [NSURL URLWithString:self.resultDict[@"codeUrl"]];
    [codeImageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"4x3比例"]];
    [_backView addSubview:codeImageV];
    
    UILabel * codeLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-180-10)/2, CGRectGetMaxY(codeImageV.frame)+7, 180+10, 14)];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.text = [NSString stringWithFormat:@"%lld",[self.resultDict[@"verificationCode"] longLongValue]];
    codeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    codeLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:codeLabel];
    
    UILabel * lastLabel = [[UILabel alloc]init];
    lastLabel.numberOfLines = 0;
    if ([_type isEqualToString:@"1"]) {
        lastLabel.frame = CGRectMake(14, CGRectGetMaxY(codeLabel.frame)+13, kScreenWidth-14*2, 80);
        NSMutableAttributedString * lastStr = nil;
        lastStr = [[NSMutableAttributedString alloc]initWithString:self.introStr0 attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [lastStr  appendAttributedString:[[NSAttributedString  alloc] initWithString:@"\n\n"attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:3]}]];
        [lastStr appendAttributedString:[[NSAttributedString alloc]initWithString:self.introStr1 attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
        lastLabel.attributedText = lastStr;
        lastLabel.textAlignment = NSTextAlignmentLeft;
        lastLabel.numberOfLines = 0;
        [_backView addSubview:lastLabel];
    }
    else
    {
        
        lastLabel.frame = CGRectMake((kScreenWidth-250)/2, CGRectGetMaxY(codeLabel.frame)+13, 250, 40);
        NSMutableAttributedString * lastStr = nil;
        lastStr = [[NSMutableAttributedString alloc]initWithString:self.introStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//        [lastStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"八一驾校" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#74db41"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
//        [lastStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"报到)" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        lastLabel.attributedText = lastStr;
        lastLabel.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:lastLabel];
    }
    
    
    UIImageView * lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lastLabel.frame)+_addHeight+8, kScreenWidth-12*2, 1)];
    if ([_type isEqualToString:@"1"]) {
        lineImageV.frame = CGRectMake(12, CGRectGetMaxY(lastLabel.frame), kScreenWidth-12*2, 1);
    }
    self.lineImageView = lineImageV;
    lineImageV.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [_backView addSubview:lineImageV];
    
    [self createDownView];
}

- (void)createDownView
{
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.lineImageView.frame)+5, kScreenWidth-12*2, 65)];
    NSMutableAttributedString * detailStr = [[NSMutableAttributedString alloc]init];
    
    if ([_type isEqualToString:@"1"]) {       //私人订制界面进来

        detailLabel.hidden = YES;
        [detailStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"学车秘书：张佳琪" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        [detailStr  appendAttributedString:[[NSAttributedString  alloc] initWithString:@"\n\n"attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:3]}]];
        [detailStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"联系方式：13999999999\n" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];

    }
    else
    {
        detailLabel.hidden = NO;

        if (self.nameStr&&self.mobileStr&&self.addressStr) {
            NSArray * messageArr = @[self.nameStr,self.mobileStr,self.addressStr];
            for (int i=0; i<3; i++) {
                
                [detailStr appendAttributedString:[[NSAttributedString alloc]initWithString:messageArr[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
                
                if (i<2) {
                    [detailStr  appendAttributedString:[[NSAttributedString  alloc] initWithString:@"\n\n"attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:3]}]];
                }
            }
        }
       

    }
    detailLabel.attributedText = detailStr;
    detailLabel.numberOfLines = 0;
    [_backView addSubview:detailLabel];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
