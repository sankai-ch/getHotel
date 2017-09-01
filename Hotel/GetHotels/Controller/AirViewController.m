//
//  AirViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/22.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "AirViewController.h"

@interface AirViewController ()
{
    NSInteger i;
}
@property (weak, nonatomic) IBOutlet UIView *xiugaitu;
@property (weak, nonatomic) IBOutlet UIView *function;
@property (weak, nonatomic) IBOutlet UIButton *strattime;
@property (weak, nonatomic) IBOutlet UIButton *endtime;
@property (weak, nonatomic) IBOutlet UIButton *fromcity;
@property (weak, nonatomic) IBOutlet UIButton *gocity;
@property (weak, nonatomic) IBOutlet UITextField *stactprice;
@property (weak, nonatomic) IBOutlet UITextField *endprice;
@property (weak, nonatomic) IBOutlet UITextField *objectiv;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UIButton *issued;
- (IBAction)issuedAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *hiddendate;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *canner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confrim;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)connerAction:(UIBarButtonItem *)sender;

- (IBAction)confrimAction:(UIBarButtonItem *)sender;

- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    // Do any additional setup after loading the view.
    [self setDefaultDateForButton];
    _xiugaitu.layer.borderColor = [UIColor colorWithRed:202/255.0f green:224/255.0f blue:251/255.0f alpha:1].CGColor;
    _xiugaitu.layer.borderWidth = 1.5f;
    _function.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _function.layer.shadowOffset = CGSizeMake(0, 0);
    _function.layer.shadowOpacity= 0.7f;
    _function.layer.shadowRadius = 4.0f;
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
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
    
}
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

- (void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    //将日期转换为字符串
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr = [formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    [_strattime setTitle:dateStr forState:UIControlStateNormal];
    [_endtime setTitle:dateTomStr forState:UIControlStateNormal];
}
- (IBAction)issuedAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
}
- (IBAction)connerAction:(UIBarButtonItem *)sender {
    _date.hidden = YES;
    _hiddendate.hidden = YES;
    _toolbar.hidden  = YES;
}

- (IBAction)confrimAction:(UIBarButtonItem *)sender {
    NSDate *date = _date.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter =[NSDateFormatter new];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd";
    //将日期转换为字符串
    NSString *theDate = [formatter stringFromDate:date];
    if(i == 0) {
        [_strattime setTitle:theDate forState:UIControlStateNormal];
    }
    if(i == 1){
        [_endtime setTitle:theDate forState:UIControlStateNormal];
        
    }
    _date.hidden = YES;
    _hiddendate.hidden = YES;
    _toolbar.hidden  = YES;
}


- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    i =0;
    _date.hidden = NO;
    _hiddendate.hidden = NO;
    _toolbar.hidden  = NO;
}

- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event {
    i =1;
    _date.hidden = NO;
    _hiddendate.hidden = NO;
    _toolbar.hidden  = NO;
}
@end
