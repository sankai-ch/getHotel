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
@interface QuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event;




@end

@implementation QuoteListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    [self setNavigationItem];
    [self request];
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
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//网络请求
#pragma mark -request
- (void)request{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    NSDictionary * para = @{@"Id":@(_Id)};
    NSLog(@"%ld",(long)_Id);
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"pay:%@",responseObject);
        if([responseObject[@"result"]integerValue]==1){
            NSArray *result = responseObject[@"content"];
           
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
                
            }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误,请稍后再试!" andTitle:@"提示" onView:self onCompletion:^{
            
        }];
    }];
}

#pragma mark -tableView
//设置有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    
    //设置支付按钮边框颜色
    cell.payButton.layer.borderColor=[UIColor colorWithRed:140/255.0f green:181/255.0f blue:249/255.0f alpha:1].CGColor;
    
    cell.layer.masksToBounds = NO;
    cell.view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    cell.view.layer.shadowRadius = 3;//阴影半径，默认3
    cell.dateNameLabel.text = @"";
    cell.airNameLabel.text = @"";
    cell.timeLabel.text = @"";
    cell.levelLabel.text = @"";
    cell.priceLabel.text = @"";
    return cell;
}
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PayViewController *purchaseVc = [Utilities  getStoryboardInstance:@"MyInfo" byIdentity:@"Purchase"];
    [self.navigationController pushViewController:purchaseVc  animated:YES];
   
    
}
@end
