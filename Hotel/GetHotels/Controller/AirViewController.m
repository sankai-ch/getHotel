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
@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSInteger status;
}

@property (strong, nonatomic) HMSegmentedControl *segmentControl;


@property (weak, nonatomic) IBOutlet UITableView *tradedTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *releaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyListTableView;


@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    status = 0;
    [self setNavigationItem];
    [self setSegmentControl];
    [self requestNet];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置导航栏样式
//设置导航栏样式

//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"我的航空";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //实例化一个button 类型为UIButtonTypeSystem
    //UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tradedTableView) {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"traded" forIndexPath:indexPath];
        return cell;
    } else if (tableView == _releaseTableView) {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTableView" forIndexPath:indexPath];
        return cell;
    } else {
        MyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryList" forIndexPath:indexPath];
        return cell;
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
    if (page == 0) {
        status = 0;
        [self requestNet];
    } else if (page == 1){
        status = 1;
        [self requestNet];
    } else {
        status = 2;
        [self requestNet];
    }
    return page;
}

#pragma mark - Request

- (void)requestNet {
    NSLog(@"%@",[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"]);
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"page":@2,@"state":@(status)};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

@end
