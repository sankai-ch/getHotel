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
#import "DOPDropDownMenu.h"

#import "textCollectionViewCell.h"
@interface HotelViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate> {

    NSInteger btnTime;
    BOOL firstVisit;
    NSInteger starlevels;
    NSInteger priceduring;
    NSInteger selectsection;
    
}
@property (weak, nonatomic) IBOutlet UIView *sequenceView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *date1;//入住时间
@property (strong, nonatomic) NSString *date2;//离店时间
@property (strong, nonatomic) NSMutableArray *hotelArr;//酒店数组
@property (strong, nonatomic) NSMutableArray *advArr;//广告数组
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIImageView *adImage1;//广告图片
@property (weak, nonatomic) IBOutlet UIImageView *adImage2;
@property (weak, nonatomic) IBOutlet UIImageView *adImage3;
@property (weak, nonatomic) IBOutlet UIImageView *adImage4;
@property (weak, nonatomic) IBOutlet UIImageView *adImage5;
@property (strong, nonatomic) NSTimer *timer; //控制轮播
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *inTime; //按钮上显示的入住时间
@property (strong, nonatomic) NSString *outTime;// 按钮上显示的离店时间
@property (strong, nonatomic) NSString *SortId;
//@property (strong, nonatomic) NSDate *flagDate;
@property (nonatomic) NSTimeInterval inTimeIn; //入住时间戳
@property (nonatomic) NSTimeInterval outTimeIn;//离店时间戳
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIView *selectBView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;


@property (strong, nonatomic) IBOutlet UIButton *a;
@property (strong, nonatomic) IBOutlet UIButton *b;
@property (strong, nonatomic) IBOutlet UIButton *c;
@property (strong, nonatomic) IBOutlet UIButton *d;
- (IBAction)cofirmAction:(UIButton *)sender forEvent:(UIEvent *)event;

//@property (strong, nonatomic) NSArray *textArr;
//代码画界面
//@property (strong, nonatomic) IBOutlet UIButton *inTimeBtn;
//@property (strong, nonatomic) IBOutlet UIButton *outTimeBtn;
//@property (strong, nonatomic) IBOutlet UIButton *orderByBtn;
//@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
//@property (strong, nonatomic) UIView *selectView;
//@property (strong, nonatomic) UIView *orederByView;
//@property (strong, nonatomic) DOPDropDownMenu *menu;
@property (strong, nonatomic) NSArray *sorts;
@property (strong, nonatomic) NSArray *select;
@property (strong, nonatomic) NSArray *starLevel;
@property (strong, nonatomic) NSArray *priceDuring;
//@property (strong, nonatomic) DOPDropDownMenu *menu;



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
    //[self setheaderViewInit];
    [self setDefaultTime];
    [self locationConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    //[self requestCiry];
    
    //[self request];
    [self requestAll];
       [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    starlevels=1;
    priceduring=1;
    selectsection=-1;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
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
    //_textArr = @[@""];
    
    _a = [UIButton new];
    _b = [UIButton new];
    _c = [UIButton new];
    _d = [UIButton new];
    _hotelTableView.tableFooterView = [UIView new];
    _selectTableView.tableFooterView = [UIView new];
    _sorts = @[@"智能排序",@"价格低到高",@"价格高到低",@"离我从远到近"];
    _select = @[@"星级",@"价格区间"];
    _starLevel = @[@"全部",@"四星",@"五星"];
    _priceDuring = @[@"不限",@"300以下",@"301-500",@"501-1000",@"1000以上"];
    _SortId = @"0";
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

//- (void)setheaderViewInit {
//    _inTimeBtn = [UIButton new];
//    _outTimeBtn = [UIButton new];
//    _orderByBtn = [UIButton new];
//    _selectBtn = [UIButton new];
//    _orederByView = [UIView new];
//    _selectView = [UIView new];
//    _selectView.hidden = YES;
//    _orederByView.hidden = YES;
//
//    _inTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    _outTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    _orderByBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    
//    [_orderByBtn setTitle:@"智能排序" forState:UIControlStateNormal];
//    [_selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
//}

- (void)setDefaultTime {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateTomorrow];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    //pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    pFormatter.dateFormat = @"yyyy-MM-dd";
    _date1 = [pFormatter stringFromDate:today];
    _date2 = [pFormatter stringFromDate:tomorrow];
    [_datePicker setMinimumDate:today];
//    [_inTimeBtn setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
//    [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
    
//    [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
//    [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
    //[_datePicker setMinimumDate:today];
    _outTimeIn = [tomorrow timeIntervalSince1970InMilliSecond];
    
    _inTimeIn = [today timeIntervalSince1970InMilliSecond];
    _inTime = [NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]];
    _outTime = [NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]];
    [_a setTitle:_inTime forState:UIControlStateNormal];
    [_b setTitle:_outTime forState:UIControlStateNormal];
    [_c setTitle:@"智能排序" forState:UIControlStateNormal];
    [_d setTitle:@"筛选" forState:UIControlStateNormal];

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
    //[_timer invalidate];
    //_timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
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
    //(startId  0 = all       2 = 4  3 = 5)
    //
    //(sortingId 2 = l - h  3 = h - l   )

    NSDictionary *para = @{@"city_name":_cityLocation.titleLabel.text,@"pageNum":@1,@"pageSize":@10,@"startId":@(starlevels),@"priceId":@(priceduring),@"sortingId":_SortId,@"inTime":_date1,@"outTime":_date2,@"wxlongitude":@"31.568",@"wxlatitude":@"120.299"};

    //NSLog(@"%@,%@",_date1,_date2);
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            if (_advArr.count == 0) {
                NSArray *advertising = responseObject[@"content"][@"advertising"];
                for (NSDictionary *dict in advertising) {
                    AAndHModel *adV = [[AAndHModel alloc] initWithDictForAD:dict];
                    [_advArr addObject:adV];
                    
                }
                [self setADImage];
            }
            
            //NSLog(@"_advArr:%@",_advArr);
            NSArray *hotel = responseObject[@"content"][@"hotel"][@"list"];
            [_hotelArr removeAllObjects];
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
        NSLog(@"%@",error);
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self onCompletion:^{
            
        }];
    }];
}
/*
- (void)request {
    //(startId  0 = all       2 = 4  3 = 5)
    //
    //(sortingId 2 = l - h  3 = h - l   )
     NSDictionary *para = @{@"city_name":@"无锡",@"pageNum":@1,@"pageSize":@10,@"startId":@0,@"priceId":@1,@"sortingId":_SortId,@"inTime":_date1,@"outTime":_date2,@"wxlongitude":@"31.568",@"wxlatitude":@"120.299"};
    //NSLog(@"%@,%@",_date1,_date2);
    [RequestAPI requestURL:@"/findHotelByCity" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"查询测试：%@",responseObject);
        [_avi stopAnimating];
       
        
    }failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
    }];
}
*/



#pragma mark - table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _selectTableView) {
        return _sorts.count;
    }
    return _hotelArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _selectTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell" forIndexPath:indexPath];
        cell.textLabel.text = _sorts[indexPath.row];
        return cell;
    }
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    NSLog(@"%ld",(long)_hotelArr.count);
    NSLog(@"%ld",(long)indexPath.row);
    AAndHModel *hotelModel = _hotelArr[indexPath.row];
    NSLog(@"123%@",hotelModel.hotelName);
    cell.hotelName.text = hotelModel.hotelName;
    NSLog(@"%@",cell.hotelName.text);
    cell.hotelPrice.text = [NSString stringWithFormat:@"¥%@",hotelModel.hotelPrice];
    NSLog(@"%@",cell.hotelPrice.text);
    NSLog(@"%@",hotelModel.hotelImg);
    NSURL *url = [NSURL URLWithString:hotelModel.hotelImg];
    NSLog(@"%@",url);
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"酒店"]];
    
    cell.hotelLocation.text = hotelModel.hotelAdd;
    NSLog(@"%@",cell.hotelLocation.text);
    cell.hotelDistance.text = [NSString stringWithFormat:@"%ld",(long)hotelModel.distance];
    NSLog(@"%@",cell.hotelDistance.text);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _selectTableView) {
        [_c setTitle:_sorts[indexPath.row] forState:UIControlStateNormal];
        switch (indexPath.row) {
            case 0:
                _SortId = @"1";
                break;
            case 1:
                _SortId = @"2";
                break;
            case 2:
                _SortId = @"3";
                break;
            default:
                _SortId = @"4";
                break;
        }
        _selectBView.hidden = YES;
        [self requestAll];
        return;
    }
    AAndHModel *hotelID = _hotelArr[indexPath.row];
    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Deatil" byIdentity:@"reservation"];
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"hotelId"];
    [[StorageMgr singletonStorageMgr] addKey:@"hotelId" andValue:@(hotelID.hotelId)];
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"customInTime"];
    [[StorageMgr singletonStorageMgr] addKey:@"customInTime" andValue:_inTime];
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"customOutTime"];
    [[StorageMgr singletonStorageMgr] addKey:@"customOutTime" andValue:_outTime];
    //UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:detailVC];
    //[self presentViewController:nc animated:YES completion:nil];
   // detailVC.hotelId = hotelID.hotelId;
   // NSLog(@"%@",detailVC.hotelid);
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    _menu= [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
//    _menu.delegate = self;
//    _menu.dataSource = self;
//    _menu.textColor = [UIColor grayColor];
//    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
//    _menu.finishedBlock = ^(DOPIndexPath *indexPath) {
//        [self requestAll];
//    };
    //[menu hideMenu]
    
    
//    JPullDownMenu *menu = [[JPullDownMenu alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 40) menuTitleArray:@[_inTime,_outTime,@"智能排序",@"筛选"]];
//    NSArray *arr = @[];
//    NSArray *arr1 = @[];
//    NSArray *arr2 = @[@"1",@"2"];
//    NSArray *arr3 = @[@"1",@"2"];
//    menu.menuDataArray = [NSMutableArray arrayWithObjects:arr,arr1,arr2,arr3, nil];
//    __weak typeof(self) _self = self;
//    [menu setHandleSelectDataBlock:^(NSString *selectTitle, NSUInteger selectIndex, NSUInteger selectButtonTag) {
//        if (selectIndex == 0) {
//            
//        }
//        
//    }];
    //view.backgroundColor = [UIColor whiteColor];
//    _inTimeBtn.titleLabel.textColor = [UIColor grayColor];
//    _outTimeBtn.titleLabel.textColor = [UIColor grayColor];
//    _orderByBtn.titleLabel.textColor = [UIColor grayColor];
//    _selectBtn.titleLabel.textColor = [UIColor grayColor];
//    _selectView.backgroundColor = [UIColor grayColor];
//    _orederByView.backgroundColor = [UIColor grayColor];
//    _inTimeBtn.frame = CGRectMake(25, 5, 65, 20);
//    _outTimeBtn.frame = CGRectMake(135, 5, 65, 20);
//    _orderByBtn.frame = CGRectMake(235, 5, 65, 20);
//    _selectBtn.frame = CGRectMake(325, 5, 65, 20);
//    [_inTimeBtn addTarget:self action:@selector(inTimeAction) forControlEvents:UIControlEventTouchUpInside];
//    [_outTimeBtn addTarget:self action:@selector(outTimeAction) forControlEvents:UIControlEventTouchUpInside];
//    [_orderByBtn addTarget:self action:@selector(showOrderView) forControlEvents:UIControlEventTouchUpInside];
//    [_orderByBtn addTarget:self action:@selector(showSelectView) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:_inTimeBtn];
//    [view addSubview:_outTimeBtn];
//    [view addSubview:_orderByBtn];
//    [view addSubview:_selectBtn];
    if (tableView == _hotelTableView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        _a.titleLabel.textColor = [UIColor whiteColor];
        _b.titleLabel.textColor = [UIColor whiteColor];
        _c.titleLabel.textColor = [UIColor whiteColor];
        _d.titleLabel.textColor = [UIColor whiteColor];
        _a.backgroundColor = [UIColor lightGrayColor];
        _b.backgroundColor = [UIColor lightGrayColor];
        _c.backgroundColor = [UIColor lightGrayColor];
        _d.backgroundColor = [UIColor lightGrayColor];
        _a.titleLabel.font = [UIFont systemFontOfSize:13];
        _b.titleLabel.font = [UIFont systemFontOfSize:13];
        _c.titleLabel.font = [UIFont systemFontOfSize:13];
        _d.titleLabel.font = [UIFont systemFontOfSize:13];
        [_a addTarget:self action:@selector(inTimeAction) forControlEvents:UIControlEventTouchUpInside];
        [_b addTarget:self action:@selector(outTimeAction) forControlEvents:UIControlEventTouchUpInside];
        [_c addTarget:self action:@selector(showSelectView) forControlEvents:UIControlEventTouchUpInside];
        [_d addTarget:self action:@selector(sequenceAt) forControlEvents:UIControlEventTouchUpInside];
        view.frame = CGRectMake(0, 0, UI_SCREEN_W, 40);
        CGFloat wd = UI_SCREEN_W/4;
        _a.frame = CGRectMake(0,0,wd,40);
        _b.frame = CGRectMake(wd,0,wd,40);
        _c.frame = CGRectMake(wd*2,0,wd,40);
        _d.frame = CGRectMake(wd*3,0,wd,40);
        
        [view addSubview:_a];
        [view addSubview:_b];
        [view addSubview:_c];
        [view addSubview:_d];
        
        return view;
    }
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _selectTableView) {
        return 0;
    }
    return 40;
}

#pragma mark - searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSDictionary *para=@{@"hotel_name":searchText,@"inTime":_date1,@"outTime":_date2};
    [RequestAPI requestURL:@"selectHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
         NSLog(@"%ld",(long)statusCode);
    }];
}




#pragma mark - btnAction

//- (void)setTimeString {
//    if (btnTime == 0) {
//        _inTime =
//    }
//}

- (void)sequenceAt{
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    _selectBView.hidden = YES;
    if(!_sequenceView.hidden){
        _sequenceView.hidden=YES;
        return;
    }
    _sequenceView.hidden=NO;
}

- (void)showSelectView {
    //[a titleForState:UIControlStateHighlighted];
    //_selectView.hidden = NO;
    _sequenceView.hidden=YES;
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    if (!_selectBView.hidden) {
        _selectBView.hidden = YES;
        return;
    }
    _selectBView.hidden = NO;
}

- (void)showOrderView {
    //[_orderByBtn titleForState:UIControlStateHighlighted];
    //_orederByView.hidden = NO;
}

- (void)inTimeAction {
    //[_inTimeBtn titleForState:UIControlStateHighlighted];
    _selectBView.hidden = YES;
    _sequenceView.hidden=YES;
    if (!_datePicker.hidden) {
        _datePicker.hidden = YES;
        _toolBar.hidden = YES;
        [_a setTitle:_inTime forState:UIControlStateNormal];
        return;
    }
    btnTime = 0;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}
- (void)outTimeAction {
    //[_outTimeBtn titleForState:UIControlStateHighlighted];
    _selectBView.hidden = YES;
    _sequenceView.hidden=YES;
    if (!_datePicker.hidden) {
        _datePicker.hidden = YES;
        _toolBar.hidden = YES;
        [_b setTitle:_outTime forState:UIControlStateNormal];
        return;
    }
    btnTime = 1;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
}

//- (IBAction)dateInAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    btnTime = 0;
//    _datePicker.hidden = NO;
//    _toolBar.hidden = NO;
//}
//
//- (IBAction)dateOutAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    btnTime = 1;
//    _datePicker.hidden = NO;
//    _toolBar.hidden = NO;
//}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    //[_menu hideMenu];
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的事件
    NSDate *date =  _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSString *theDate = [formatter stringFromDate:date];
    NSTimeInterval Time = [date timeIntervalSince1970InMilliSecond];
//    NSTimeInterval Time = [Utilities cTimestampFromString:theDate format:@"MM-dd"];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    //pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    pFormatter.dateFormat = @"yyyy-MM-dd";
    if (btnTime == 0) {
        if (Time > _outTimeIn) {
            [Utilities popUpAlertViewWithMsg:@"请选择正确的入住时间" andTitle:nil onView:self onCompletion:^{
                
            }];
            return;
        }
        _inTimeIn = Time;
        _inTime = [NSString stringWithFormat:@"入住%@",theDate];
        [_a setTitle:_inTime forState:UIControlStateNormal];
//        [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
//        [_datePicker setMinimumDate:date];
        _date1 = [pFormatter stringFromDate:date];
    }
    else {
        if (Time < _inTimeIn) {
            [Utilities popUpAlertViewWithMsg:@"请选择正确的离店时间" andTitle:nil onView:self onCompletion:^{
                
            }];
            return;
        }
        _outTimeIn = Time;
        _outTime = [NSString stringWithFormat:@"离店%@",theDate];
        [_b setTitle:_outTime forState:UIControlStateNormal];
//        [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
//        _date2 = [pFormatter stringFromDate:date];
    }
    
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    [self requestAll];
}

#pragma mark - collection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每组有多少个items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==_collectionView2){
        return _starLevel.count;
    }
    else
    {
        return _priceDuring.count;
    }
}
//每个items长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if(collectionView==_collectionView2){
        textCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell2"forIndexPath:indexPath];
        cell.cellLabel2.text=_starLevel[indexPath.row];
        return cell;
    }
    else{
        textCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"forIndexPath:indexPath];
        cell.cellLabel.text=_priceDuring[indexPath.row];
        return cell;
    }
    
 }
//设置细胞尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat x=self.view.frame.size.width;
//    CGFloat space=self.view.frame.size.width/200;
//    return CGSizeMake((x-space*3)/4,(x-space*3)/4);
    return CGSizeMake(62, 15);
}
//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  self.view.frame.size.width/100;
}
//设置细胞的横向间距。
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.view.frame.size.width/30;
}

//UI    w被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{   selectsection=indexPath.section;
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    if(collectionView==_collectionView2){
        switch (indexPath.row) {
            case 0:
                starlevels=1;
                break;
                case 1:
                starlevels=2;
                break;
            case 2:
                starlevels=3;
            default:
                break;
        }
    }
    if(collectionView==_collectionView){
        switch (indexPath.row) {
            case 0:
                priceduring=1;
                break;
            case 1:
                priceduring=2;
                break;
            case 2:
                priceduring=3;
                break;
            case 3:
                priceduring=4;
                break;
            case 4:
                priceduring=5;
                break;
            default:
                break;
        }
    }
}

//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
   
    NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
}
- (IBAction)cofirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _sequenceView.hidden=YES;
    [self requestAll];
}
@end
