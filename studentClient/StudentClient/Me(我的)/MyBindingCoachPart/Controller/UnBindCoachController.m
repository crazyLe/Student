//
//  UnBindCoachController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "UnBindCoachController.h"
#import "UnBindCoachCell.h"
#import "BindCoachController.h"
#import "MyCoachViewController.h"

@interface UnBindCoachController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;



@end

@implementation UnBindCoachController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
    
    [self createNavigation];
    
    [self createUI];
    
}

-(void)createUI
{
    //创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"UnBindCoachCell" bundle:nil] forCellReuseIdentifier:@"UnBindCoachCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];


}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 325;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"UnBindCoachCell";
    UnBindCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.clickBtnBlock = ^(UnBindCoachSubjectType type){
        NSString *sub;
        if (0 == type ) {
            sub = @"second";
        }else
        {
            sub = @"thred";
        }
        BindCoachController *bindVC = [[BindCoachController alloc]init];
        bindVC.sub = sub;
        [self.navigationController pushViewController:bindVC animated:YES];
        
        
//        switch (type) {
//            case UnBindCoachSubject2:
//            {
//            
//                BindCoachController *bindVC = [[BindCoachController alloc]init];
//                
//                [self.navigationController pushViewController:bindVC animated:YES];
//            
//            }
//                break;
//            case UnBindCoachSubject3:
//            {
//                MyCoachViewController *mycoachVC = [[MyCoachViewController alloc]init];
//                [self.navigationController pushViewController:mycoachVC animated:YES];
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
    
    
    
    };
    return cell;
    
}
- (void)createNavigation {
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"我的教练"];
}
- (void)leftBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
