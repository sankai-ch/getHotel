//
//  MyHotelViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyHotelViewController.h"
#import "HMSegmentedControl.h"
#import "HotelOrderTableViewCell.h"
#import "HotelOrdersModel.h"

@interface MyHotelViewController ()<UITableViewDelegate,UITableViewDelegate,UIScrollViewDelegate>{
    NSInteger allPageNum;
    NSInteger availablePageNum;
    NSInteger historyPageNum;
    NSInteger pageSize;
    bool allLastPage;
    bool availableLastPage;
    bool historyLastPage;
    
    bool allFirst;
    bool availableFirst;
    bool historyFirst;
    
}
@property (strong, nonatomic) HMSegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *allOrdersTableView;
@property (weak, nonatomic) IBOutlet UITableView *availableTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSMutableArray *allArr;
@property (strong, nonatomic) NSMutableArray *availableArr;
@property (strong, nonatomic) NSMutableArray *historyListArr;
@property (strong, nonatomic) UIActivityIndicatorView *avi;

@property (strong, nonatomic) UIImageView *allNothingImg;
@property (strong, nonatomic) UIImageView *availableNothingImg;
@property (strong, nonatomic) UIImageView *historyNothingImg;
@end

@implementation MyHotelViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self setSegmentControl];
    [self setfooterView];
    [self dataInit];
    [self initRequestAll];
    [self setRefreshControl];
    if(_allArr.count == 0){
        [self nothingForTableView];
    }
    
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

- (void)dataInit{
    availableFirst = true;
    historyFirst = true;
    //status = 0;
    allPageNum = 1;
    pageSize = 4;
    availablePageNum = 1;
    historyPageNum = 1;
    _allArr = [NSMutableArray new];
    _availableArr = [NSMutableArray new];
    _historyListArr = [NSMutableArray new];
}

#pragma mark - 设置导航栏
//设置导航栏样式
- (void)naviConfig{
    self.navigationItem.title = @"我的酒店";
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

#pragma mark - 设置菜单栏
- (void)setSegmentControl {
    _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
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
}



#pragma mark - ref
- (void)setRefreshControl {
    UIRefreshControl *ref1 = [UIRefreshControl new];
    [ref1 addTarget:self action:@selector(allRef) forControlEvents:UIControlEventValueChanged];
    ref1.tag = 10001;
    [_allOrdersTableView addSubview:ref1];
    UIRefreshControl *ref2 = [UIRefreshControl new];
    [ref2 addTarget:self action:@selector(availableRef) forControlEvents:UIControlEventValueChanged];
    ref2.tag = 10002;
    [_availableTableView addSubview:ref2];
    UIRefreshControl *ref3 = [UIRefreshControl new];
    [ref3 addTarget:self action:@selector(historyRef) forControlEvents:UIControlEventValueChanged];
    ref3.tag = 10003;
    [_historyTableView addSubview:ref3];
}

- (void)allRef{
    allPageNum = 1;
    [self requestAll];
}
- (void)availableRef {
    availablePageNum = 1;
    [self requestAvailable];
}

- (void)historyRef {
    historyPageNum = 1;
    [self requestHistory];
}


#pragma mark - TableView
- (void)setfooterView {
    _allOrdersTableView.tableFooterView = [UIView new];
    _availableTableView.tableFooterView = [UIView new];
    _historyTableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _allOrdersTableView) {
        return _allArr.count;
    } else if (tableView == _availableTableView) {
        return _availableArr.count;
    }
    return _historyListArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _allOrdersTableView) {
        HotelOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCell" forIndexPath:indexPath];
        HotelOrdersModel *model=_allArr[indexPath.section];
        
        NSString *hotel_type = model.hotelType;
        NSString *hotel_name = model.hotelName;
        NSString *str1 = [hotel_type substringFromIndex:2];
        NSRange range = [str1 rangeOfString:@"房"];
        NSString *str2 = [str1 substringToIndex:range.location];
        NSString *nameType = [hotel_name stringByAppendingString:str2];
        cell.hotelNameLabel.text = [nameType stringByAppendingString:@"房"];
        cell.areaLabel.text = model.area;
        cell.remarkLabel.text = model.remark;
        cell.checkIntime.text= model.checkInTime;
        cell.checkOutTime.text = model.checkOutTime;
        cell.hotelImage.image = [UIImage imageNamed:@"blueHotel"];
        return cell;
    } else if (tableView == _availableTableView) {
        HotelOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avaliableCell" forIndexPath:indexPath];
        HotelOrdersModel *model=_availableArr[indexPath.section];
        NSString *hotel_type = model.hotelType;
        NSString *hotel_name = model.hotelName;
        NSString *str1 = [hotel_type substringFromIndex:2];
        NSRange range = [str1 rangeOfString:@"房"];
        NSString *str2 = [str1 substringToIndex:range.location];
        NSString *nameType = [hotel_name stringByAppendingString:str2];
        cell.hotelNameLabel.text = [nameType stringByAppendingString:@"房"];
        cell.areaLabel.text = model.area;
        cell.remarkLabel.text = model.remark;
        cell.checkIntime.text= model.checkInTime;
        cell.checkOutTime.text = model.checkOutTime;
        cell.hotelImage.image = [UIImage imageNamed:@"blueHotel"];
        return cell;
    } else {
        HotelOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        HotelOrdersModel *model=_historyListArr[indexPath.section];
        NSString *hotel_type = model.hotelType;
        NSString *hotel_name = model.hotelName;
        NSString *str1 = [hotel_type substringFromIndex:2];
        NSRange range = [str1 rangeOfString:@"房"];
        NSString *str2 = [str1 substringToIndex:range.location];
        NSString *nameType = [hotel_name stringByAppendingString:str2];
        cell.hotelNameLabel.text = [nameType stringByAppendingString:@"房"];
        cell.areaLabel.text = model.area;
        cell.remarkLabel.text = model.remark;
        cell.checkIntime.text= model.checkInTime;
        cell.checkOutTime.text = model.checkOutTime;
        cell.hotelImage.image = [UIImage imageNamed:@"my_hotel"];

        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _availableTableView) {
        if (indexPath.section == _availableArr.count -1) {
            if (availableFirst) {
                availablePageNum ++;
                [self requestAvailable];
            }
        }
    } else if (tableView == _historyTableView) {
        if (indexPath.section == _historyListArr.count - 1) {
            if (historyFirst) {
                historyPageNum ++;
                [self requestHistory];
            }
        }
    }else if (tableView == _allOrdersTableView) {
        if (indexPath.section == _allArr.count - 1) {
            if (allFirst) {
                allPageNum ++;
                [self requestAll];
            }
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - Scorll
//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        NSLog(@"page = %ld",(long)page);
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
    if (page == 1 && availableFirst){
        availableFirst = false;
        [self initRequestAvailable];
    } else if (page == 2 && historyFirst) {
        historyFirst = false;
        [self initRequestHistory];
    }
    return page;
}


- (void)initRequestAll {
    _avi = [Utilities getCoverOnView:self.view];
    [self requestAll];
}

- (void)initRequestAvailable {
    _avi = [Utilities getCoverOnView:self.view];
    [self requestAvailable];
}

- (void)initRequestHistory {
    _avi = [Utilities getCoverOnView:self.view];
    [self requestHistory];
}

-(void)nothingForTableView{
    _allNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _allNothingImg.frame = CGRectMake((UI_SCREEN_W - 100)/2, 50, 100, 100);
    
    _availableNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _availableNothingImg.frame = CGRectMake(UI_SCREEN_W + (UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    _historyNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _historyNothingImg.frame = CGRectMake(UI_SCREEN_W * 2 + (UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    [_scrollView addSubview:_allNothingImg];
    [_scrollView addSubview:_availableNothingImg];
    [_scrollView addSubview:_historyNothingImg];
}


#pragma mark - Request
- (void)requestAll {
    UIRefreshControl *ref = [_allOrdersTableView viewWithTag:10001];
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"id":@1};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        [ref endRefreshing];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"];
            if (allPageNum == 1) {
                [_allArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                HotelOrdersModel *hotelOrderModel = [[HotelOrdersModel alloc] initWithDict:dict];
                [_allArr addObject:hotelOrderModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            if(_allArr.count == 0){
                _allNothingImg.hidden = NO;
            }else{
                _allNothingImg.hidden = YES;
            }
            
            [_allOrdersTableView reloadData];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self onCompletion:^{
                
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];
}



- (void)requestAvailable {
    UIRefreshControl *ref = [_availableTableView viewWithTag:10002];
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"id":@2};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        [ref endRefreshing];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"];
            if (availablePageNum == 1) {
                [_availableArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                HotelOrdersModel *hotelOrderModel = [[HotelOrdersModel alloc] initWithDict:dict];
                [_availableArr addObject:hotelOrderModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            if(_availableArr.count == 0){
                _availableNothingImg.hidden = NO;
            }else{
                _availableNothingImg.hidden = YES;
            }
            [_availableTableView reloadData];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self onCompletion:^{
                
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];

    
}

- (void)requestHistory {
    UIRefreshControl *ref = [_historyTableView viewWithTag:10003];
    NSDictionary *para = @{@"openid":[[StorageMgr singletonStorageMgr] objectForKey:@"OpenId"],@"id":@3};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        [ref endRefreshing];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *list = responseObject[@"content"];
            if (historyPageNum == 1) {
                [_historyListArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                HotelOrdersModel *hotelOrderModel = [[HotelOrdersModel alloc] initWithDict:dict];
                [_historyListArr addObject:hotelOrderModel];
                //NSLog(@"timer = %f",aviationModel.timeRequest);
            }
            //当数组没有数据时将图片显示，反之隐藏
            if (_historyListArr.count == 0) {
                _historyNothingImg.hidden = NO;
            }else{
                _historyNothingImg.hidden = YES;
            }

            [_historyTableView reloadData];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self onCompletion:^{
                
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"%@",error);
        [_avi stopAnimating];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];

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
