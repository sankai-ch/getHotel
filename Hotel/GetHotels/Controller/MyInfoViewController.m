//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "UserModel.h"

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSArray *myInfoArr;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _myInfoArr = @[@{@"leftIcon":@"hotel",@"title":@"我的酒店"},@{@"leftIcon":@"aviation",@"title":@"我的航空"},@{@"leftIcon":@"我的消息",@"title":@"我的消息"},@{@"leftIcon":@"setting",@"title":@"账户设置"},@{@"leftIcon":@"protocol",@"title":@"使用协议"},@{@"leftIcon":@"电话",@"title":@"联系客服"}];    // Do any additional setup after loading the view.
    [self setNavigationItem];
   


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if([Utilities loginCheck]){
        //已登录
        _loginBtn.hidden=YES;
        _nameLabel.hidden=NO;
        UserModel *user=[[StorageMgr singletonStorageMgr]objectForKey:@"UserInfo"];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.headImg]placeholderImage:[UIImage imageNamed:@"用户"]];
        _nameLabel.text=user.nickName;
        _grade.hidden=NO;
        UIImage  *stars=[UIImage imageNamed:@"star"];
        switch (user.state) {
            case 1:
                _star1.image=stars;
                break;
                case 2:
                _star1.image=stars;
                _star2.image=stars;
                case 3:
                _star1.image=stars;
                _star2.image=stars;
                _star3.image=stars;
            default:
                break;
        }
       
        
    }
    else{
        _loginBtn.hidden=NO;
        _nameLabel.hidden=YES;
        
        _grade.hidden=YES;
        _headImageView.image=[UIImage imageNamed:@"用户"];
        _nameLabel.text=@"游客";
    }
}
/*
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"我的";
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
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
 */
//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"我的";
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setSegment{
}

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
    if (section == 2) {
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
    if([Utilities loginCheck]){
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

    }else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    
    }
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
