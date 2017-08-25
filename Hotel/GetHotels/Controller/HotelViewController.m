//
//  HotelViewController.m
//  GetHotels
//
//  Created by ll on 2017/8/23.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "HotelViewController.h"
#import "HotelTableViewCell.h"
#import "DetailViewController.h"
#import "AAndHModel.h"
#import <CoreLocation/CoreLocation.h>
@interface HotelViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CLLocationManagerDelegate> {
    NSInteger btnTime;
    BOOL firstVisit;
    
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *date1;
@property (strong, nonatomic) NSString *date2;
@property (strong, nonatomic) NSMutableArray *hotelArr;
@property (strong, nonatomic) NSMutableArray *advArr;
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIImageView *adImage1;
@property (weak, nonatomic) IBOutlet UIImageView *adImage2;
@property (weak, nonatomic) IBOutlet UIImageView *adImage3;
@property (weak, nonatomic) IBOutlet UIImageView *adImage4;
@property (weak, nonatomic) IBOutlet UIImageView *adImage5;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *inTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *outTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderByBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;


@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) CLLocation *location;


- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;




@end

@implementation HotelViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dataInitialize];
    [self naviConfig];
    [self setDefaultTime];
    [self locationConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    //[self requestCiry];
    [self requestAll];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    [_locMgr stopUpdatingLocation];
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

#pragma mark - init

- (void)dataInitialize {
    _avi = [Utilities getCoverOnView:self.view];
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //是第一次打开APP
        appInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //第一次打开APP
            appInit = YES;
        }
    }
    if (appInit) {
        //第一次来到页面将默认城市与记忆城市同步
        NSString *userCity = _cityLocation.titleLabel.text;
        [Utilities setUserDefaults:@"UserCity" content:userCity];
    } else {
        //不是第一次来到APP则将记忆城市与按钮上的城市名反向同步
        NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
        [_cityLocation setTitle:userCity forState:UIControlStateNormal];
        
    }
    
    firstVisit = YES;

    _hotelArr = [NSMutableArray new];
    _advArr = [NSMutableArray new];
}

- (void)setDefaultTime {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateTomorrow];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    _date1 = [pFormatter stringFromDate:today];
    _date2 = [pFormatter stringFromDate:tomorrow];
    _inTimeBtn = [UIButton new];
    _outTimeBtn = [UIButton new];
    _orderByBtn = [UIButton new];
    _selectBtn = [UIButton new];
    _inTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _outTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _orderByBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_inTimeBtn setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
    [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
    [_orderByBtn setTitle:@"智能排序" forState:UIControlStateNormal];
    [_selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
//    [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
//    [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
    [_datePicker setMinimumDate:today];
    
}

- (void)setADImage {
    NSMutableArray *urlArr = [NSMutableArray new];
    
    for (AAndHModel *adv in _advArr) {
        [urlArr addObject:adv.adImg];
    }
    //NSLog(@"%@",urlArr);
    
    
    
    [_adImage1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_adImage2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_adImage3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_adImage4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_adImage5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
}



#pragma mark - pageAndScorll

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
//        //NSLog(@"%d", page);
//    
//    // 设置页码
//    //_pageController.currentPage = page;
//}

//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [_timer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
    //[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
    //NSLog(@"开启定时器");
    [_timer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
}




- (void)changeImage {
    NSInteger page = [self scrollCheck:_scrollView];
    [_scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W *(page+1), 0, UI_SCREEN_W, 150) animated:YES];
}
- (NSInteger)scrollCheck: (UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 4) {
        page = -1;
    }
    //NSLog(@"%ld",(long)page);
    return page;
}

#pragma mark - loction
//这个方法专门处理定位的基本设置
- (void)locationConfig {
    //初始化
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //识别定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
}

//这个方法处理开始定位
- (void)locationStart {
    //判断用户有没有选择过是否使用定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        if ([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
#endif
    }
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
    
}



//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self onCompletion:^{
                    
                }];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:@"未打开定位" andTitle:nil onView:self onCompletion:^{
                    
                }];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:@"未知地址" andTitle:nil onView:self onCompletion:^{
                    
                }];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:@"未知错误" andTitle:nil onView:self onCompletion:^{
                    
                }];
                break;
        }
    }
}


//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"维度 ：%f",newLocation.coordinate.latitude);
    //NSLog(@"经度 ：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
   
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    
}


- (void)getRegeoViaCoordinate {
    //duration表示从NOW开始过三个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某件事  GCD = dispatch
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                //从placemarks中拿到地址信息
                //CLPlacemark *first = placemarks[0];
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                
                //NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:cityStr.length - 1];
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"locDict"];
                //将定位到的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"locDict" andValue:cityStr];
                //NSLog(@"city = %@",cityStr);
                if (firstVisit) {
                    firstVisit = !firstVisit;
                    if (![_cityLocation.titleLabel.text isEqualToString:cityStr]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,是否切换？",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //修改城市按钮标题
                            [_cityLocation setTitle:cityStr forState:UIControlStateNormal];
                            //删除记忆体
                            [Utilities removeUserDefaults:@"UserCity"];
                            //添加记忆体
                            [Utilities setUserDefaults:@"UserCity" content:cityStr];
                            //网络请求
                            [self requestAll];
                        
                        }];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:confirm];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        }];
        //三秒后关掉开关
        [_locMgr stopUpdatingLocation];
    });
   
}

#pragma mark - notification

- (void)checkCityState: (NSNotification *)note {
    NSString *cityStr = note.object;
    if (![_cityLocation.titleLabel.text isEqualToString:cityStr]) {
        //修改城市按钮标题
        [_cityLocation setTitle:cityStr forState:UIControlStateNormal];
        //删除记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        //添加记忆体
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self requestAll];
    }
}


#pragma mark - naviConfig
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"GetHotel";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - request 

//- (void)requestCiry {
//    [RequestAPI requestURL:@"/findCity" withParameters:@{@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSInteger statusCode, NSError *error) {
//        
//    }];
//}


- (void)requestAll {
    
    NSDictionary *para = @{@"startId":@1,@"priceId":@0,@"sortingId":@1,@"inTime":_date1,@"outTime":_date2,@"page":@5};
    //NSLog(@"%@,%@",_date1,_date2);
    [RequestAPI requestURL:@"/findAllHotelAndAdvertising" withParameters:para andHeader:nil byMethod:kForm andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 0) {
            NSArray *advertising = responseObject[@"content"][@"advertising"];
            for (NSDictionary *dict in advertising) {
                AAndHModel *adV = [[AAndHModel alloc] initWithDictForAD:dict];
                [_advArr addObject:adV];
                
            }
            [self setADImage];
            //NSLog(@"_advArr:%@",_advArr);
            NSArray *hotel = responseObject[@"content"][@"hotel"];
            for (NSDictionary *dict in hotel) {
                AAndHModel *hotelModel = [[AAndHModel alloc] initWithDictForHotelCell:dict];
                //NSLog(@"%@",hotelModel.hotelName);
                [_hotelArr addObject:hotelModel];
                
            }
//                        AAndHModel *hotel1 = _hotelArr[0];
//                        NSLog(@"%@",hotel1.hotelName);
//                        NSLog(@"%@",hotel1.hotelPrice);
            [_hotelTableView reloadData];
        }
        
    }failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
    }];
}


#pragma mark - table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hotelArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    //NSLog(@"%ld",(long)indexPath.row);
    AAndHModel *hotelModel = _hotelArr[indexPath.row];
    //NSLog(@"123%@",hotelModel.hotelName);
    cell.hotelName.text = hotelModel.hotelName;
    //NSLog(@"%@",cell.hotelName.text);
    cell.hotelPrice.text = [NSString stringWithFormat:@"¥%@",hotelModel.hotelPrice];
    //NSLog(@"%@",cell.hotelPrice.text);
    //NSLog(@"%@",hotelModel.hotelImg);
    NSURL *url = [NSURL URLWithString:hotelModel.hotelImg];
    NSLog(@"%@",url);
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"酒店"]];
    
    cell.hotelLocation.text = hotelModel.hotelAdd;
    cell.hotelDistance.text = hotelModel.distance;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AAndHModel *hotelID = _hotelArr[indexPath.row];
    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Deatil" byIdentity:@"reservation"];
    //UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:detailVC];
    //[self presentViewController:nc animated:YES completion:nil];
    //detailVC.hotelid = hotelID.hotelId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    _inTimeBtn.titleLabel.textColor = [UIColor blueColor];
    _outTimeBtn.titleLabel.textColor = [UIColor blueColor];
    _orderByBtn.titleLabel.textColor = [UIColor blueColor];
    _selectBtn.titleLabel.textColor = [UIColor blueColor];
    _inTimeBtn.frame = CGRectMake(25, 5, 65, 20);
    _outTimeBtn.frame = CGRectMake(135, 5, 65, 20);
    _orderByBtn.frame = CGRectMake(235, 5, 65, 20);
    _selectBtn.frame = CGRectMake(325, 5, 65, 20);
    [_inTimeBtn addTarget:self action:@selector(inTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [_outTimeBtn addTarget:self action:@selector(outTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_inTimeBtn];
    [view addSubview:_outTimeBtn];
    [view addSubview:_orderByBtn];
    [view addSubview:_selectBtn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark - btnAction

- (void)inTimeAction {
    [_inTimeBtn titleForState:UIControlStateHighlighted];
    btnTime = 0;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}
- (void)outTimeAction {
    [_outTimeBtn titleForState:UIControlStateHighlighted];
    btnTime = 1;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}

- (IBAction)dateInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    btnTime = 0;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}

- (IBAction)dateOutAction:(UIButton *)sender forEvent:(UIEvent *)event {
    btnTime = 1;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的事件
    NSDate *date =  _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSString *theDate = [formatter stringFromDate:date];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    if (btnTime == 0) {
        [_inTimeBtn setTitle:[NSString stringWithFormat:@"入住%@", theDate] forState:UIControlStateNormal];
        [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
        [_datePicker setMinimumDate:date];
        _date1 = [pFormatter stringFromDate:date];
    }
    else {
        
        [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
        _date2 = [pFormatter stringFromDate:date];
    }
    
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    [self requestAll];
}
@end
