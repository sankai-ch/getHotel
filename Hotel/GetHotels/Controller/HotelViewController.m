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
@interface HotelViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger btnTime;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *dateInBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateOutBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *date1;
@property (strong, nonatomic) NSString *date2;


- (IBAction)dateInAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dateOutAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;




@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self setDefaultTime];
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

- (void)setDefaultTime {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateTomorrow];
    _date1 = [formatter stringFromDate:today];
    _date2 = [formatter stringFromDate:tomorrow];
    [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", _date1] forState:UIControlStateNormal];
    [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", _date2] forState:UIControlStateNormal];
    [_datePicker setMinimumDate:today];
    
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

- (void)requestAll {
    NSDictionary *para = @{};
    [RequestAPI requestURL:@"/findAllHotelAndAdvertising" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}


#pragma mark - table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Deatil" byIdentity:@"reservation"];
    //UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:detailVC];
    //[self presentViewController:nc animated:YES completion:nil];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - btnAction

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

    if (btnTime == 0) {
        [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", theDate] forState:UIControlStateNormal];
        [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
        [_datePicker setMinimumDate:date];
    }
    else {
        
        [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
    }
    
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
}
@end
