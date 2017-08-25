//
//  MyHotelViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyHotelViewController.h"
#import "AllOrdersTableViewCell.h"
#import "AvailableTableViewCell.h"
#import "ExpiredTableViewCell.h"
#import "HMSegmentedControl.h"
#import "UserModel.h"
@interface MyHotelViewController ()<UITableViewDelegate,UITableViewDelegate,UIScrollViewDelegate>{
    NSInteger allOrdersPageNum;
    NSInteger availablePageNum;
    NSInteger ExpiredPageNum;
    
    NSInteger availableFlag;
    NSInteger expiredFlag;
    
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *AllOrdersTableView;
@property (weak, nonatomic) IBOutlet UITableView *AvailableTableView;
@property (weak, nonatomic) IBOutlet UITableView *ExpiredTableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (strong, nonatomic) NSMutableArray *allOrdersArr;
@property (strong, nonatomic) NSMutableArray *availableArr;
@property (strong, nonatomic) NSMutableArray *expiredArr;

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *avi;




@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    
    availableFlag = 1;
    expiredFlag = 1;
    
    allOrdersPageNum = 1;
    availablePageNum = 1;
    ExpiredPageNum = 1;
    
    _allOrdersArr = [NSMutableArray new];
    _availableArr = [NSMutableArray new];
    _expiredArr = [NSMutableArray new];
    
    //[self allOrdersRequest];
    [self setSegment];
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

/*

#pragma mark - refreshControl
//创建刷新指示器的方法
- (void)setRefreshControl{
    //全部订单的刷新指示器
    UIRefreshControl *allOrdersRef = [UIRefreshControl new];
    [allOrdersRef addTarget:self action:@selector(allOrdersRef) forControlEvents:UIControlEventValueChanged];
    allOrdersRef.tag = 10001;
    [_AllOrdersTableView addSubview:allOrdersRef];
    
    //可使用的刷新指示器
    UIRefreshControl *avaRef = [UIRefreshControl new];
    [avaRef addTarget:self action:@selector(avaRef) forControlEvents:UIControlEventValueChanged];
    avaRef.tag = 10002;
    [_AvailableTableView addSubview:avaRef];
    
    //未过期的刷新指示器
    UIRefreshControl *expiredRef = [UIRefreshControl new];
    [expiredRef addTarget:self action:@selector(expiredRef) forControlEvents:UIControlEventValueChanged];
    expiredRef.tag = 10003;
    [_ExpiredTableView addSubview:expiredRef];
}

//已获取列表下拉刷新事件
- (void)acquireRef{
    allOrdersPageNum = 1;
    [self allOrdersRequest];
}
//未获取列表下拉刷新事件
- (void)notAcquireRef{
    availablePageNum = 1;
    [self allOrdersRequest];
}
//跟进列表下拉刷新事件
- (void)followRef{
    ExpiredPageNum = 1;
    [self allOrdersRequest];
}

*/

#pragma mark - scrollView

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //NSLog(@"page = %ld", (long)page);
        //将_segmentedControl设置选中的index为page（scrollView当前显示的tableview）
        [_segmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}
//scrollView已经结束滑动的动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
//判断scrollView滑动到那里了
- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    
    if (availableFlag == 1 && page == 1) {
        availableFlag = 0;
        NSLog(@"第一次滑动scollview来到可获取");
        //[self notAcquireInitializeData];
    }
    if (expiredFlag == 1 && page == 2) {
        expiredFlag = 0;
        NSLog(@"第一次滑动scollview来到已过期");
       // [self followInitializeData];
    }
    
    return page;
}

//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
- (void)allOrdersInitializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self allOrdersRequest];
}
#pragma mark - request
//全部订单网络请求
- (void)allOrdersRequest{
    UserModel *user = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"wxcode":user.openId,@"id":user.userId};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
       
        NSLog(@"request:%@",responseObject);
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}


#pragma mark - setSegment设置菜单栏

//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
    //设置位置
    _segmentedControl.frame = CGRectMake(0, 60, UI_SCREEN_W, 60);
    //设置默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //设置菜单栏的背景色
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置线的高度
    _segmentedControl.selectionIndicatorHeight = 2.5f;
    _segmentedControl.selectionIndicatorColor = UIColorFromRGB(21, 126, 251);
    //设置选中状态的样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //选中时的标记的位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(111, 113, 121, 1),NSFontAttributeName:[UIFont systemFontOfSize:17]};
    //选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(21, 126, 251, 1),NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    
    [self.view addSubview:_segmentedControl];
}



//设置导航栏样式
- (void)setNavigationItem{
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _AllOrdersTableView) {
        return _allOrdersArr.count;
    }else if (tableView == _AvailableTableView) {
        return _availableArr.count;
    }else{
        return _expiredArr.count;
    }
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *homeImg = [UIImage imageNamed:@"Home"];
    //NSLog(@"进入allordersTableView");
    NSDictionary *dict = @{@"hotelAddressLAbel":@"江苏省无锡市",@"hotelPeopleNumLabel":@"三人入住",@"hotelTypeLabel":@"超级无敌海景房",@"startDateLabel":@"2018-12-12",@"endDateLabel":@"2019-01-11",@"hotelImg":homeImg};
    if (tableView == _AllOrdersTableView) {
        AllOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allOrdersCell" forIndexPath:indexPath];
        NSLog(@"进入allordersTableView");
        
        
        
        cell.hotelTypeLabel.text = @"342342";
        cell.hotelAddressLAbel.text = dict[@"hotelAddressLAbel"];
        cell.hotelPeopleNumLabel.text = dict[@"hotelPeopleNumLabel"];
        cell.startDateLabel.text = dict[@"startDateLabel"];
        cell.endDateLabel.text = dict[@"endDateLabel"];
        cell.hotelImg.image = dict[@"homeImg"];
        
        return cell;
        
    }else if (tableView == _AvailableTableView) {
        AvailableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"availableCell" forIndexPath:indexPath];
       // [_availableArr addObject:dict];
        
        dict = _availableArr[indexPath.section];
        cell.hotelTypeLabel.text = @"342342";
        cell.hotelAddressLabel.text = dict[@"hotelAddressLAbel"];
        cell.hotelPeopleNumLabel.text = dict[@"hotelPeopleNumLabel"];
        cell.startDateLabel.text = dict[@"startDateLabel"];
        cell.endDateLabel.text = dict[@"endDateLabel"];
        cell.hotelImg.image = dict[@"homeImg"];
        return cell;
    }else{
        ExpiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expiredCell" forIndexPath:indexPath];
        
        dict = _expiredArr[indexPath.section];
        //[_expiredArr addObject:dict];
        cell.hotelTypeLabel.text = @"342342";
        cell.hotelAddressLabel.text = dict[@"hotelAddressLAbel"];
        cell.hotelPeopleNumLabel.text = dict[@"hotelPeopleNumLabel"];
        cell.startDateLabel.text = dict[@"startDateLabel"];
        cell.endDateLabel.text = dict[@"endDateLabel"];
        cell.hotelImg.image = dict[@"homeImg"];
        return cell;
    }
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

@end
