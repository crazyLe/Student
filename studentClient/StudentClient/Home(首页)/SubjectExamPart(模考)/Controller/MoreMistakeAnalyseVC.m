//
//  MoreMistakeAnalyseVC.m
//  学员端
//
//  Created by zuweizhong  on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MoreMistakeAnalyseVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "QuestionBottomView.h"
#import "TuCaoCell.h"
#import "TuCaoHeaderCell.h"
#import <IQUIView+IQKeyboardToolbar.h>

@interface MoreMistakeAnalyseVC ()<UITableViewDelegate,UITableViewDataSource,QuestionBottomViewDelegate,TuCaoCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)QuestionBottomView * bottomView;

@property(nonatomic,assign)int pageId;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation MoreMistakeAnalyseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"试题分析"];
    
    self.pageId = 1;
    
    [self createUI];
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    
}
-(void)loadData
{

    NSString *url = self.interfaceManager.questionsCommentList;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentList" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionModel.idNum);
    param[@"pageId"] = @(self.pageId);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr1 = dict[@"info"][@"data"];
            
            self.dataArray = [QuestionCommentModel mj_objectArrayWithKeyValuesArray:arr1];
            
            [self.hudManager dismissSVHud];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
            [self.tableView.mj_header endRefreshing];

        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        
        [self.tableView.mj_header endRefreshing];

    }];

}
-(void)loadMoreData
{
    
    NSString *url = self.interfaceManager.questionsCommentList;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentList" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionModel.idNum);
    param[@"pageId"] = @(self.pageId);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr1 = dict[@"info"][@"data"];
            
            NSArray *temp = [QuestionCommentModel mj_objectArrayWithKeyValuesArray:arr1];
            
            [self.dataArray addObjectsFromArray:temp];
            
            [self.hudManager dismissSVHud];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}
-(void)createUI
{
    //创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-50) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = BG_COLOR;
    [tableView setExtraCellLineHidden];
    [tableView setCellLineFullInScreen];
    tableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:tableView];
    tableView.fd_debugLogEnabled = YES;
    [tableView registerNib:[UINib nibWithNibName:@"TuCaoCell" bundle:nil] forCellReuseIdentifier:@"TuCaoCell"];
    
    //创建底部的BottomView
    QuestionBottomView *bottomView = [[[NSBundle mainBundle]loadNibNamed:@"QuestionBottomView" owner:nil options:nil]lastObject];
    self.bottomView = bottomView;
    self.bottomView.questionModel = self.currentQuestionModel;
    bottomView.correctBtn.hidden = YES;
    bottomView.incorrectBtn.hidden = YES;
    bottomView.questionHudBtn.hidden = YES;
    bottomView.inputTextField.hidden = NO;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(@50);
    }];
    
    [self.bottomView.inputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];

    
    __weak typeof (self) weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageId = 1;

        [weakSelf loadData];

    }];

    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageId ++;
        
        [weakSelf loadMoreData];
        
    }];
    
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    [self.tableView.mj_header beginRefreshing];


}
-(void)doneAction:(id)item
{
    
    if ([self.bottomView.inputTextField.text isEqualToString:@""]||self.bottomView.inputTextField.text == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"评论不能为空" hideAfterDelay:1.0];
        return;
    }
    [self.bottomView.inputTextField resignFirstResponder];

    [self.hudManager showNormalStateSVHUDWithTitle:@"正在评论..."];
    NSString *url = self.interfaceManager.questionSayUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/questionSay" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionModel.idNum);
    param[@"content"] = self.bottomView.inputTextField.text;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {

            [self.hudManager showSuccessSVHudWithTitle:@"评论成功" hideAfterDelay:1.0 animaton:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadData];
            });
            
            
        }
        else if(code == 2)
        {
            //验证失败，去登录
            LoginGuideController *loginVC = [[LoginGuideController alloc]init];
            JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
            loginnavC.fullScreenPopGestureEnabled = YES;
            self.view.window.rootViewController = loginnavC;
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
    _bottomView.inputTextField.text = nil;
    
}
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(ExamQuestionModel *)questionModel
{
    [bottomView.inputTextField becomeFirstResponder];
}
#pragma mark - TableViewDelegate & DataSoure

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return 44;
    }
    else {
        CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"TuCaoCell" cacheByIndexPath:indexPath configuration:^(TuCaoCell * cell) {
            cell.commentModel = self.dataArray[indexPath.row-1];

        }];
        return height;
    }
    return 200;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *identify = @"TuCaoHeaderCell";
        TuCaoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuCaoHeaderCell" owner:nil options:nil]lastObject];
        }
        return cell;

    }
    else
    {
        
        static NSString *identify = @"TuCaoCell";
        TuCaoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuCaoCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.commentModel = self.dataArray[indexPath.row-1];
        return cell;

    }
    return nil;
    
}
-(void)tuCaoCell:(TuCaoCell *)cell didClickZanBtnWithModel:(QuestionCommentModel *)model
{
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *url = self.interfaceManager.commentLikeUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentLike" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"commentsId"] = @(model.commentsId);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            
            model.is_like = YES;
            
            [self.tableView reloadData];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
