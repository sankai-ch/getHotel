//
//  ViewController.m
//  hawudha
//
//  Created by admin1 on 2017/8/30.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "QuoteListViewController.h"
#import "QuoteListTableViewCell.h"
#import "PurchaseTableViewController.h"
@interface QuoteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event;




@end

@implementation QuoteListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    [self naviConfig];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -navigation
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"报价列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:5/255.0f green:100/255.0f blue:240/255.0f alpha:1];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    //self.navigationController.navigationBar.translucent = YES;
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
    
    return cell;
}
+ (id)getStoryboardInstance:(NSString *)sbName byIdentity:(NSString *)identity
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}
- (IBAction)payButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PurchaseTableViewController *purchaseVc = [ QuoteListViewController getStoryboardInstance:@"Main" byIdentity:@"Purchase"];
    [self.navigationController pushViewController:purchaseVc  animated:YES];
   
    
}
@end
