//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSArray *myInfoArr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myInfoArr = @[@{@"leftIcon":@"酒店",@"title":@"我的酒店"},@{@"leftIcon":@"航空",@"title":@"我的航空"},@{@"leftIcon":@"我的消息",@"title":@"我的消息"},@{@"leftIcon":@"账号与安全",@"title":@"账户设置"},@{@"leftIcon":@"我的消息",@"title":@"使用协议"},@{@"leftIcon":@"电话",@"title":@"联系客服"}];    // Do any additional setup after loading the view.
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
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.iconView.image = [UIImage imageNamed:dict[@"leftIcon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"ToHotel" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"ToAir" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"ToMessage" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"ToSafe" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"ToProtocol" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"ToCall" sender:self];
            break;
    }
}
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
