//
//  dituViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/23.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "dituViewController.h"
#import <CoreLocation/CoreLocation.h>
#import<MapKit/MapKit.h>
#import "Annotation.h"
@interface dituViewController ()<CLLocationManagerDelegate, MKMapViewDelegate> {
    NSInteger count;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *longitudeLabel;
@property (strong, nonatomic) UILabel *latitudeLabel;


@end

@implementation dituViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    count = 0;
//    //初始化位置管理器对象作为定位功能的基础
//    _locationManager = [[CLLocationManager alloc] init];
//    //签署协议
//    _locationManager.delegate = self;
//    //表示每移动多少距离可以被识别
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    //表示把地球分割的精度（分割成边长为多少的小方块）
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    //判断用户有没有决定过要不要使用定位功能（如果没有就执行if语句里面的操作）
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        //判断设备是否为iOS8.0以上系统
//#ifdef __IPHONE_8_0
//        //表示询问用户是否要使用定位功能（但是如果info.plist文件内没有设置好询问的语句内容，则不会出现弹窗）（requestWhenInUseAuthorization：表示当APP运行过程中使用定位；requestAlwaysAuthorization：表示只要装着这个APP就使用定位功能）
//        [_locationManager requestWhenInUseAuthorization];
//#endif
//    }
//    //开始持续获取用户设备坐标（开关打开）
//    [_locationManager startUpdatingLocation];
    
    //创建一个地图视图，将它设置为与根视图同一位置
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //签署协议
    _mapView.delegate = self;
    //表示地图可以缩放
    _mapView.zoomEnabled = YES;
    //表示地图可以移动
    _mapView.scrollEnabled = YES;
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    //表示显示用户位置
    _mapView.showsUserLocation = YES;
    //将地图视图放到根视图上
    [self.view addSubview:_mapView];
    
    CLLocationCoordinate2D mapCoordinate;
    mapCoordinate.latitude = [_array[0] doubleValue];
    NSLog(@"%lf", [_array[0] doubleValue]);
    
    mapCoordinate.longitude = [_array[1] doubleValue];
    NSLog(@"%lf", [_array[1] doubleValue]);
    [self pinAnnotationViaCoordinate:mapCoordinate];
    //初始化MKCoordinateRegion这个视角对象
    MKCoordinateRegion region;
    //初始化MKCoordinateSpan这个缩放值对象
    MKCoordinateSpan span;
    //设置x和y方向上具体的视角缩放值
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    //初始化CLLocationCoordinate2D这个坐标对象
   
    //设置具体经纬度作为视角中心点
    //将设置好点缩放值和中心点打包放入region结构中
    region.span = span;
    region.center = mapCoordinate;
    //将打包好的视角结构作为参数运用到map view的设置视角的方法中去
    [_mapView setRegion:region animated:YES];

    //初始化一个长按手势，设置手势被识别时要执行的方法
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    //将手势添加到地图视图上
//    [_mapView addGestureRecognizer:longPress];
    
//    _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.f, self.view.frame.size.width / 2, 50.f)];
//    _longitudeLabel.backgroundColor = [UIColor clearColor];
//    _longitudeLabel.font =[UIFont systemFontOfSize:17.f];
//    _longitudeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_longitudeLabel];
//    
//    _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 50.f, self.view.frame.size.width / 2, 50.f)];
//    _latitudeLabel.backgroundColor = [UIColor clearColor];
//    _latitudeLabel.font =[UIFont systemFontOfSize:17.f];
//    _latitudeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_latitudeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当设备位置变化时执行以下方法，如果位置不变也会每秒执行一次（必须当开关打开时才会执行）（只有当distanceFilter属性是0时，该方法才会每秒调用）
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    BOOL shouldUpdate = NO;
//    if (++ count == 1) {
//        shouldUpdate = YES;
//    } else {
//        if (newLocation.coordinate.longitude != oldLocation.coordinate.longitude || newLocation.coordinate.latitude != oldLocation.coordinate.latitude) {
//            shouldUpdate = YES;
//        }
//    }
//    if (shouldUpdate) {
//        NSLog(@"CLLocation经度：%f", newLocation.coordinate.longitude);
//        NSLog(@"CLLocation纬度：%f", newLocation.coordinate.latitude);
//        _longitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
//        _latitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
//    }
//    //停止获取用户坐标（关闭开关）
//    //[manager stopUpdatingLocation];
//    //过5秒钟后停止获取用户坐标（关闭开关）
//    [manager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:5.f];
//    /*
//     dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
//     dispatch_after(time, dispatch_get_main_queue(), ^{
//     [manager stopUpdatingLocation];
//     });
//     */
//}

//当设备获取坐标失败时调用以下方法
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    if (error) {
//        [self checkError:error];
//    }
//}

#pragma mark - MKMapViewDelegate

//当设备位置更新时调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"MKUserLocation经度：%f", userLocation.coordinate.longitude);
    NSLog(@"MKUserLocation纬度：%f", userLocation.coordinate.latitude);
    
//    //初始化MKCoordinateRegion这个视角对象
//    MKCoordinateRegion region;
//    //初始化MKCoordinateSpan这个缩放值对象
//    MKCoordinateSpan span;
//    //设置x和y方向上具体的视角缩放值
//    span.longitudeDelta = 0.01;
//    span.latitudeDelta = 0.01;
//    //初始化CLLocationCoordinate2D这个坐标对象
//    CLLocationCoordinate2D location;
//    //设置具体经纬度作为视角中心点
//    location.longitude = userLocation.coordinate.longitude;
//    location.latitude = userLocation.coordinate.latitude;
//    //将设置好点缩放值和中心点打包放入region结构中
//    region.span = span;
//    region.center = location;
//    //将打包好的视角结构作为参数运用到map view的设置视角的方法中去
//    [mapView setRegion:region animated:YES];
}

//当地图加载失败时调用
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    if (error) {
        [self checkError:error];
    }
}

#pragma mark - Private

//错误判断与处理
- (void)checkError:(NSError *)error {
    switch (error.code) {
        case kCLErrorNetwork: {
            NSLog(@"没网");
        }
            break;
        case kCLErrorDenied: {
            NSLog(@"没开定位");
        }
            break;
        case kCLErrorLocationUnknown: {
            NSLog(@"荒山野岭，定位不到");
        }
            break;
        default: {
            NSLog(@"其他");
        }
            break;
    }
}

//- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
//    //长按手势以Began状态作为被识别的标志
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"长按");
//        //获得手势（这里是长按手势）在指定视图坐标系中的位置（locationInView是获得单个手指位置的方法）
//        CGPoint touchPoint = [sender locationInView:_mapView];
//        //将touchPoint这个在地图视图上触摸的点转换成地图对应的坐标
//        CLLocationCoordinate2D mapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
//        [self pinAnnotationViaCoordinate:mapCoordinate];
//    }
//}

//根据坐标创建大头针并安插
- (void)pinAnnotationViaCoordinate:(CLLocationCoordinate2D)mapCoordinate {
    //设置弱引用的自身以供block使用来解开强引用循环（双下划线）
    __weak dituViewController *weakSelf = self;
    //设置大头针的标题与副标题
    [self setAnnotationWithDescriptionOnCoordinate:mapCoordinate completionHandler:^(NSDictionary *info) {
        //初始化一个大头针对象
        Annotation *annotation = [[Annotation alloc] init];
        //将方法参数中的坐标设置为大头针的坐标属性
        annotation.coordinate = mapCoordinate;
        if (info) {
            //设置大头针的标题与副标题属性
            annotation.title = info[@"FormattedAddressLines"][0];
        
           
        }
        //将大头针插入地图视图
        [weakSelf.mapView addAnnotation:annotation];
    }];
}

//逆地理编码方法（这里是block的声明方式（创建block甲方的方式），看！看！看！！！）
- (void)setAnnotationWithDescriptionOnCoordinate:(CLLocationCoordinate2D)mapCoordinate completionHandler:(void (^)(NSDictionary *info))annotationCompletionHandler {
    //初始化一个地理编码对象
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    //将CLLocationCoordinate2D对象转换成CLLocation对象
    CLLocation *annoLoc = [[CLLocation alloc] initWithLatitude:mapCoordinate.latitude longitude:mapCoordinate.longitude];
    //执行逆地理编码方法
    [revGeo reverseGeocodeLocation:annoLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            //获取成功得到逆地理编码结果中的地址信息字典
            NSDictionary *info = [placemarks[0] addressDictionary];
            NSLog(@"info = %@", info);
            //在此处触发annotationCompletionHandler这个block发生，并把info作为参数传递给方法执行方（乙方）（由此可见，此block会在逆地理编码成功获得信息后触发）
            annotationCompletionHandler(info);
        } else {
            [self checkError:error];
            annotationCompletionHandler(nil);
        }
    }];
}



//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"酒店位置";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 236);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
