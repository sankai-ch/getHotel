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

@interface HotelViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger btnTime;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *dateInBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateOutBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *date1;
@property (strong, nonatomic) NSString *date2;
@property (strong, nonatomic) NSMutableArray *hotelArr;
@property (strong, nonatomic) NSMutableArray *advArr;
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;


- (IBAction)dateInAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dateOutAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;




@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _advArr = [NSMutableArray new];
    _hotelArr = [NSMutableArray new];
    [self naviConfig];
    [self setDefaultTime];
    //[self requestCiry];
    [self requestAll];
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
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    _date1 = [pFormatter stringFromDate:today];
    _date2 = [pFormatter stringFromDate:tomorrow];
    [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
    [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
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

- (void)requestCiry {
    [RequestAPI requestURL:@"/findCity" withParameters:@{@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}


- (void)requestAll {
    
    NSDictionary *para = @{@"startId":@1,@"priceId":@0,@"sortingId":@1,@"inTime":_date1,@"outTime":_date2,@"page":@5};
    //NSLog(@"%@,%@",_date1,_date2);
    [RequestAPI requestURL:@"/findAllHotelAndAdvertising" withParameters:para andHeader:nil byMethod:kForm andSerializer:kForm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            NSArray *advertising = responseObject[@"content"][@"advertising"];
            NSArray *hotel = responseObject[@"content"][@"hotel"];
            for (NSDictionary *dict in hotel) {
                AAndHModel *hotelModel = [[AAndHModel alloc] initWithDictForHotelCell:dict];
                //NSLog(@"%@",hotelModel.hotelName);
                [_hotelArr addObject:hotelModel];
                
            }
//            AAndHModel *hotel1 = _hotelArr[0];
//            NSLog(@"%@",hotel1.hotelName);
//            NSLog(@"%@",hotel1.hotelPrice);
            [_hotelTableView reloadData];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
        NSLog(@"%@",error);
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
    NSURL *url = [NSURL URLWithString:hotelModel.hotelImg];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.hotelImage.image = [UIImage imageWithData:data];
    
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
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSSZ";
    if (btnTime == 0) {
        [_dateInBtn setTitle:[NSString stringWithFormat:@"入住%@", theDate] forState:UIControlStateNormal];
        [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
        [_datePicker setMinimumDate:date];
        _date1 = [pFormatter stringFromDate:date];
    }
    else {
        
        [_dateOutBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
        _date2 = [pFormatter stringFromDate:date];
    }
    [self requestAll];
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
}
@end
