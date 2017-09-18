//
//  ViewController.m
//  hawudha
//
//  Created by admin1 on 2017/8/30.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "QuoteListViewController.h"
#import "QuoteListTableViewCell.h"
#import "PayViewController.h"
#import "QuoteModel.h"
#import "PayViewController.h"
@interface QuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageNum;
}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSMutableArray *quoteArr;
@property (strong, nonatomic) UIImageView *noTradedImage;


@end

@implementation QuoteListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _quoteArr = [NSMutableArray new];
    [self setNavigationItem];
    [self setRefreshControl];
    [self inittializeData];
    //去掉tableview底部多余的线
    _tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -navigation
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"报价列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100,240);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ref
- (void)setRefreshControl {
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(releaseRef) forControlEvents:UIControlEventValueChanged];
    ref.tag = 99998;
    [_tableView addSubview:ref];
    
}

- (void)releaseRef {
    pageNum = 1;
  
    [self request];
}
- (void)nothingFotTradedTableView {
    _noTradedImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_things"]];
    _noTradedImage.frame = CGRectMake((UI_SCREEN_W - 100) / 2, 100, 100, 100);
    
    [_tableView addSubview:_noTradedImage];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
- (void)inittializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self request];
}//网络请求
#pragma mark -request
- (void)request{
   
    
    NSDictionary * para = @{@"Id":@(_Id)};
    NSLog(@"%ld",(long)_Id);
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_tableView viewWithTag:99998];
        [ref endRefreshing];
        NSLog(@"pay:%@",responseObject);
        if([responseObject[@"result"]integerValue]==1){
            NSDictionary *result = responseObject[@"content"];
            NSLog(@"result=%@",result);
            if (pageNum == 1) {
                [_quoteArr removeAllObjects];
            }
            for (NSDictionary *dict in result) {
                QuoteModel *model =[[QuoteModel alloc]initWithDict:dict];
                [_quoteArr addObject:model];
                
            }
            _noTradedImage.hidden = YES;
            switch (_quoteArr.count) {
                case 0:
                    [self nothingFotTradedTableView];
                    
                    _noTradedImage.hidden = NO;
                    break;
                    
                default:
                    _noTradedImage.hidden = YES;
                    break;
            }
            [_tableView reloadData];
           
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
                
            }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误,请稍后再试!" andTitle:@"提示" onView:self onCompletion:^{
            
        }];
    }];
}

#pragma mark -tableView
//设置有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _quoteArr.count;
}
//设置每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//设置每组的头部视图高度为20
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//设置每组头部视图长什么样
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    QuoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quoteCell" forIndexPath:indexPath];
    QuoteModel *model = _quoteArr[indexPath.row];
    [[StorageMgr singletonStorageMgr]addKey:@"Model" andValue:model];
    //设置支付按钮边框颜色
    cell.payButton.layer.borderColor=[UIColor colorWithRed:140/255.0f green:181/255.0f blue:249/255.0f alpha:1].CGColor;
    
    cell.layer.masksToBounds = NO;
    cell.view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    cell.view.layer.shadowRadius = 3;//阴影半径，默认3
    
    NSDate *inDate =[NSDate dateWithTimeIntervalSince1970:[model.in_time integerValue]/1000 ];
    NSDateFormatter *inFormatter = [NSDateFormatter new];
    NSDateFormatter *inFormatter1 = [NSDateFormatter new];
    inFormatter.dateFormat = @"M-dd";
    inFormatter1.dateFormat = @"HH:mm";
    NSString *in_date = [inFormatter stringFromDate:inDate];
    NSString *in_time = [inFormatter1 stringFromDate:inDate];
    
    NSDate *outDate =[NSDate dateWithTimeIntervalSince1970:[model.out_time integerValue]/1000 ];
  
    
    NSDateFormatter *outFormatter = [NSDateFormatter new];
    outFormatter.dateFormat = @"HH:mm";
    NSString *out_time = [outFormatter stringFromDate:outDate];
    
    cell.dateNameLabel.text = [NSString stringWithFormat:@"%@ %@——%@ 机票",in_date,model.departure,model.destination];
    cell.airNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.aviation_company,model.flight_no];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",in_time,out_time];
    cell.levelLabel.text = model.aviation_cabin;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %ld",(long)model.final_price];
    return cell;
}
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PayViewController *purchaseVc = [Utilities  getStoryboardInstance:@"MyInfo" byIdentity:@"Purchase"];
    [self.navigationController pushViewController:purchaseVc  animated:YES];
    purchaseVc.model = [[StorageMgr singletonStorageMgr]objectForKey:@"Model"];
}
@end
