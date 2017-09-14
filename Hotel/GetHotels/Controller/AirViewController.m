//
//  AirViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/22.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "AirViewController.h"
#import "HMSegmentedControl.h"
#import "MyIssueTableViewCell.h"
#import "MyAviationModel.h"
#import "QuoteListViewController.h"
@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSInteger status;
    NSInteger RpageNum;
    NSInteger TpageNum;
    NSInteger HpageNum;
    NSInteger pageSize;
    bool RLastPage;
    bool TLastPage;
    bool HLastPage;
    
    bool RFirst;
    bool TFirst;
    bool HFirst;
}

@property (strong, nonatomic) HMSegmentedControl *segmentControl;


@property (weak, nonatomic) IBOutlet UITableView *tradedTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *releaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyListTableView;
@property (strong, nonatomic) NSMutableArray *releaseArr;
@property (strong, nonatomic) NSMutableArray *tradedArr;
@property (strong, nonatomic) NSMutableArray *historyListArr;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RFirst = true;
    TFirst = true;
    HFirst = true;
    status = 0;
    RpageNum = 1;
    pageSize = 4;
    TpageNum = 1;
    HpageNum = 1;
    _releaseArr = [NSMutableArray new];
    _tradedArr = [NSMutableArray new];
    _historyListArr = [NSMutableArray new];
//    RLastPage = false;
//    TLastPage = false;
//    HLastPage = false;
    [self naviConfig];
    [self setSegmentControl];
    //[self requestNet];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuoteListViewController *quotListVC = segue.destinationViewController;
    quotListVC.Id = [sender integerValue];
    
}

//设置导航栏样式
- (void)naviConfig{
    self.navigationItem.title = @"我的航空";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setSegmentControl {
    _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已成交",@"正在发布",@"历史发布"]];
    _segmentControl.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height, UI_SCREEN_W, 40);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.backgroundColor = [UIColor whiteColor];
    _segmentControl.selectionIndicatorHeight = 2.5f;
    //设置选中状态的样式
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //选中时标记的位置
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(230, 230, 230, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    //设置选中时的标题样式
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    __weak typeof (self) weakSelf = self;
    [_segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    [self.view addSubview:_segmentControl];
    //bujiu 
}


#pragma mark - ref
- (void)setRefreshControl {
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(releaseRef) forControlEvents:UIControlEventValueChanged];
    ref.tag = 99998;
    [_releaseTableView addSubview:ref];
}

- (void)releaseRef {
    RpageNum = 1;
    [self requestRelease];
}

//}

/*
//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"我的航空";
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    // UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    // self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
}
*/

#pragma mark - TableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tradedTableView) {
        return 1;
    } else if (tableView == _releaseTableView) {
        return _releaseArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tradedTableView) {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"traded" forIndexPath:indexPath];
        return cell;
    } else if (tableView == _releaseTableView) {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTableView" forIndexPath:indexPath];
        MyAviationModel *model = _releaseArr[indexPath.row];
        cell.ticketLabel.text = [NSString stringWithFormat:@"%@ %@ 机票",model.startTime,model.aviationDemandTitle];
        cell.priceLabel.text = [NSString stringWithFormat:@"价格区间:%ld-%ld",(long)model.lowPrice,(long)model.highPrice];
        cell.timeLabel.text = [NSString stringWithFormat:@"大约%@点左右",model.timeRequest];
        cell.demandLabel.text = model.aviationDemandDetail;
        
        return cell;
    } else {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryList" forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _releaseTableView) {
        MyAviationModel *model = _releaseArr[indexPath.row];
        NSInteger Id = model.Id;
        [self performSegueWithIdentifier:@"IssueToDetail" sender:@(Id)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _releaseTableView) {
        if (indexPath.row == _releaseArr.count -1) {
            if (!RLastPage) {
                RpageNum ++;
                [self requestRelease];
                
            }
        }
    }
    
}

#pragma mark - Scorll
//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //NSLog(@"page = %ld",(long)page);
        //将_segmentedControl设置选中的index为page【scrollview当前显示的tableview】
        [_segmentControl setSelectedSegmentIndex:page animated:YES];
    }
}
//scorllView已经结束滑动的动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
//判断我们的scroll滚到哪里了
- (NSInteger)scrollCheck : (UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    if (page == 0 && TFirst) {
        TFirst = false;
        
        [self requestTraped];
        
    } else if (page == 1 && RFirst){
        RFirst = false;
        [self requestRelease];
        
    } else if (page == 2 && HFirst) {
        HFirst = false;
        [self requestHistory];
        
    }
    return page;
}

- (void)initrequestTraped {
    status = 0;
    _avi = [Utilities getCoverOnView:_tradedTableView];
    [self requestTraped];
}

- (void)initrequestRelease {
    status = 1;//正在发布
    _avi = [Utilities getCoverOnView:_releaseTableView];
    [self requestRelease];
}

- (void)initrequestHistory {
    status = 2;
    _avi = [Utilities getCoverOnView:_historyListTableView];
    [self requestHistory];
}

#pragma mark - Request

- (void)requestRelease {
    //NSLog(@"%@",[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"]);
    
    //UIRefreshControl *ref = []
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"pageNum":@(RpageNum),@"pageSize":@(pageSize),@"state":@2};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"][@"list"];
            RLastPage = [responseObject[@"content"][@"isLastPage"] boolValue];
            if (RpageNum == 1) {
                [_releaseArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                MyAviationModel *aviationModel = [[MyAviationModel alloc] initWithDict:dict];
                [_releaseArr addObject:aviationModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            [_releaseTableView reloadData];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];
}

- (void)requestTraped {
    //NSLog(@"%@",[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"]);
    //UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"pageNum":@(TpageNum),@"pageSize":@(pageSize),@"state":@0};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"][@"list"];
            for (NSDictionary *dict in list) {
                MyAviationModel *aviationModel = [[MyAviationModel alloc] initWithDict:dict];
                [_tradedArr addObject:aviationModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            [_tradedTableView reloadData];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];
}

- (void)requestHistory {
    //NSLog(@"%@",[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"]);
    //UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"pageNum":@(HpageNum),@"pageSize":@(pageSize),@"state":@1};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"][@"list"];
            for (NSDictionary *dict in list) {
                MyAviationModel *aviationModel = [[MyAviationModel alloc] initWithDict:dict];
                [_historyListArr addObject:aviationModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            [_historyListTableView reloadData];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];
}

@end
