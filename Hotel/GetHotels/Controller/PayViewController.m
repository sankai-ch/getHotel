//
//  PayViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/9/1.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()<UITabBarDelegate,UITableViewDataSource>{
    
        NSInteger seleced;
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong,nonatomic) NSArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *tablView;
- (IBAction)butAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uilayout];
    [self datainitalize];
    [self setNavigationItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipalyResult" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uilayout{
  
    _nameLbl.text = [NSString stringWithFormat:@"%@公司 %@——%@",_model.aviation_company,_model.departure,_model.destination];
    
    NSDate *inDate =[NSDate dateWithTimeIntervalSince1970:[_model.in_time integerValue]/1000 ];
    NSDateFormatter *inFormatter = [NSDateFormatter new];
    NSDateFormatter *inFormatter1 = [NSDateFormatter new];
    inFormatter.dateFormat = @"M月dd日";
    inFormatter1.dateFormat = @"HH:mm";
    NSString *in_date = [inFormatter stringFromDate:inDate];
    NSString *in_time = [inFormatter1 stringFromDate:inDate];
    _starttime.text = [NSString stringWithFormat:@"%@ %@ 起飞",in_date,in_time];
    _price.text=[NSString stringWithFormat:@"%ld元",(long)_model.final_price];
    
    //去掉线
    self.tablView.tableFooterView = [UIView new];
    self.tablView.editing = YES;
    //创建index
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码选中表格视图中某个细胞
    [self.tablView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
}



//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"支付";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}






-(void)purchaseResultAction :(NSNotification *) note{
    NSString *result = note.object;
    if([result isEqualToString:@"9000"])
    {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"支付" message:@"恭喜你，你已经成功支付" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
    }else{
        //失败
        
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请确保账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self onCompletion:nil];
    }
    
}




-(void)datainitalize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
//设置每组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}
//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != seleced) {
        seleced = indexPath.row;
        //遍历表格视图中所有选中状态下的细胞
        for(NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
            //当选中的细胞不是当前正在按的这个细胞情况下
            if(eachIP != indexPath){
                //将细胞从选中状态改为不选中状态
                [tableView deselectRowAtIndexPath:eachIP animated:YES];
            }else{
                //[tableView deselectRowAtIndexPath:eachIP animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == seleced) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)butAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    switch (self.tablView.indexPathForSelectedRow.row) {
        case 0:
        {
     
       
            NSString *teadeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName: _nameLbl.text amount:_price.text tradeNO:teadeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@ 机票价格",_nameLbl.text] itBPay:@"30"];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
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
