//
//  DetailViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    NSInteger Flag;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIDatePicker *time;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cencer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirm;
@property (weak, nonatomic) IBOutlet UIImageView *imaget;
@property (weak, nonatomic) IBOutlet UILabel *jiudian;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *hotelbed;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UIButton *tidu;
- (IBAction)dituAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *timeday;
@property (weak, nonatomic) IBOutlet UIButton *timeday1;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *weiliao;
@property (weak, nonatomic) IBOutlet UIButton *goumai;

- (IBAction)weiiaoAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)concer:(UIBarButtonItem *)sender;
- (IBAction)confirm:(UIBarButtonItem *)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"酒店预订";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//设置默认时间
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
    [_timeday setTitle:dateStr forState:UIControlStateNormal];
    [_timeday1 setTitle:dateTomStr forState:UIControlStateNormal];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - button
- (IBAction)dituAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [self performSegueWithIdentifier:@"ditu" sender:nil];
}
- (IBAction)weiiaoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"weiliao" sender:nil];
}

- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"zhifu" sender:nil];

}

- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    Flag = 0;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    Flag = 1;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)concer:(UIBarButtonItem *)sender {
    _toolbar.hidden = YES;
    _time.hidden = YES;
}

- (IBAction)confirm:(UIBarButtonItem *)sender {
    //拿到当前datePicker选择时间
    NSDate *date = _time.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter =[NSDateFormatter new];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd";
    //将日期转换为字符串
    NSString *theDate = [formatter stringFromDate:date];
    if(Flag == 0){
        [_timeday setTitle:theDate forState:UIControlStateNormal];
    }else{
        [_timeday1 setTitle:theDate forState:UIControlStateNormal];
    }
    _toolbar.hidden = YES;
    _time.hidden = YES;
}
- (void)request{
    NSDictionary * para = @{@"id":@1};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"hotel:%@",responseObject);
        if([responseObject[@"result"]integerValue]==0){
            
        }else{
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
@end
