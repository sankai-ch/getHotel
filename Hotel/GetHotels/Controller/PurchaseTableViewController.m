//
//  PurchaseTableViewController.m
//  ios_3_Acti
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PurchaseTableViewController.h"

@interface PurchaseTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong,nonatomic) NSArray *arr;
@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uilayout];
    [self datainitalize];
    [self naviConfig];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"支付";
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"支付" style: UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
}
//支付按钮
- (void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row ) {
        case 0:{
            
//            NSString *teadeNo = [GBAlipayManager generateTradeNO];
//            [GBAlipayManager alipayWithProductName:_activity.name amount:_activity.applyFee tradeNO:teadeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@活动报名费",_activity.name] itBPay:@"30"];
        }
            break;
        case 1:{
        }
            break;
        case 2:{
        }
            break;
        default:
            break;
    }
    
}

//当收到通知后要执行的方法
- (void)purchaseResultAction: (NSNotification *)note {
    
    NSString *result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您,您已成功完成报名" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //失败
        //[Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请确保账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}

-(void)uilayout{
//    _nameLbl.text = _activity.name;
//    _contentLbl.text = _activity.content;
//    _priceLbl.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    //去掉线
    self.tableView.tableFooterView = [UIView new];
    self.tableView.editing = YES;
    //创建index
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码选中表格视图中某个细胞
    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)datainitalize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
    
    return 20.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格中所有选中的细胞
    for (NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
        //当选中的细胞不是当前正在选中的细胞的情况下，
        if(eachIP != indexPath){
            //将细胞从选中状态改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
