//
//  AgreementViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
@property (weak, nonatomic) IBOutlet UITextView *agreement;




@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self dataInitialize];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dataInitialize {
    //创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //获取要读取的文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"txt"];
    //判断路径下是否存在文件
    if ([fileMgr fileExistsAtPath:filePath]) {
        //将文件内容读取为对应的格式
       
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        //判断读取到的内容是否存在（判断文件是否损坏）
        if (str) {
       
        _agreement.text = str;
        
        
         }
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
/*
//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"使用协议";
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
*/
//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"使用协议";
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
    //设置位置大小
 
}

@end
