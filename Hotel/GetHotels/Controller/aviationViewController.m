//
//  aviationViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "aviationViewController.h"
#import "CityListViewController.h"
@interface aviationViewController ()
{
    NSInteger i;
    NSInteger j;
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

@property (weak, nonatomic) IBOutlet UIView *hdview;
- (IBAction)confrimAction:(UIBarButtonItem *)sender;

- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)formcityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)gocity:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation aviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    // Do any additional setup after loading the view.
    [self setDefaultDateForButton];
    [self backclor];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hdAction)];
    [_hdview addGestureRecognizer:tap];
   
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Tag"];
    [[StorageMgr singletonStorageMgr] addKey:@"Tag" andValue:@2];
      NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
    [_fromcity setTitle:userCity forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"fly" object:nil];
}


-(void)backclor{
    _xiugaitu.layer.borderColor = [UIColor colorWithRed:202/255.0f green:224/255.0f blue:251/255.0f alpha:1].CGColor;
    _xiugaitu.layer.borderWidth = 1.5f;
    _function.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _function.layer.shadowOffset = CGSizeMake(0, 0);
    _function.layer.shadowOpacity= 0.7f;
    _function.layer.shadowRadius = 4.0f;
    _stactprice.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _stactprice.layer.borderWidth = 1.0;
    _endprice.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _endprice.layer.borderWidth = 1.0;

}
-(void)hdAction{
    _hdview.hidden = YES;
    _hiddendate.hidden = YES;
    _date.hidden = YES;
    
    _toolbar.hidden  = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}



- (void)checkCityState: (NSNotification *)note {
    
    NSString *cityStr = note.object;
    if(j == 0)
    {
    if (![_fromcity.titleLabel.text isEqualToString:cityStr]) {
        //修改城市按钮标题
        [_fromcity setTitle:cityStr forState:UIControlStateNormal];
        //删除记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        //添加记忆体
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
    }
    }else{
        if (![_gocity.titleLabel.text isEqualToString:cityStr]) {
            //修改城市按钮标题
            [_gocity setTitle:cityStr forState:UIControlStateNormal];
            //删除记忆体
            
        }
    }
}
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
     _hdview.hidden = YES;
     _hiddendate.hidden = YES;
    _date.hidden = YES;
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
    _hdview.hidden = YES;
    _hiddendate.hidden = YES;
    _date.hidden = YES;
    
    _toolbar.hidden  = YES;
}


- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    i =0;
     _hdview.hidden = NO;
     _hiddendate.hidden = NO;
    _date.hidden = NO;
   
    _toolbar.hidden  = NO;
}

- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event {
    i =1;
      _hdview.hidden = NO;
     _hiddendate.hidden = NO;
    _date.hidden = NO;
   
    _toolbar.hidden  = NO;
}


//初始城市
- (IBAction)formcityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    j=0;
 
    CityListViewController *vc = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"flypath"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
     [self presentViewController:nc animated:YES completion:nil];
    //[self dell];
}

//到达城市
- (IBAction)gocity:(UIButton *)sender forEvent:(UIEvent *)event {
    j=1;
        CityListViewController *vc = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"flypath"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
@end
