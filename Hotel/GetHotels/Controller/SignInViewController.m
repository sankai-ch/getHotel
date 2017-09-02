//
//  SignInViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()<UITextFieldDelegate>
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)SignInAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _signInBtn.enabled = NO;

    [self naviConfig];
    [self setShadow];
    [self uiLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uiLayout{
    _avatar.layer.borderColor=[UIColor blueColor].CGColor;

}

- (void)setShadow {
    
    _shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _shadowImageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shadowImageView.layer.shadowOpacity = 0.7f;//阴影透明度，默认0
    _shadowImageView.layer.shadowRadius = 4.f;//阴影半径，默认3
}

//设置导航栏样式
- (void)naviConfig{
    self.navigationItem.title = @"会员注册";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //实例化一个button 类型为UIButtonTypeSystem
    //UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
//    self.navigationItem.title = @"会员注册";
//    
//    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
//    //设置导航条的颜色（风格颜色）
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
//    //设置导航栏标题的风格
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    //实例化一个button 类型为UIButtonTypeSystem
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    //设置位置大小
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    //[leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    //[leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
//- (void)leftButtonAction: (UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _phoneTextField || textField == _pwdTextField || textField == _confirmPwdTextField) {
        if (_phoneTextField.text.length != 0 && _pwdTextField.text.length != 0 && _confirmPwdTextField.text.length != 0) {
            _signInBtn.enabled =YES;
        }
    }
}
//按键盘的return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneTextField || textField == _pwdTextField || textField == _confirmPwdTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SignInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_phoneTextField.text.length==0 ||_phoneTextField.text.length<11){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号" andTitle:nil onView:self onCompletion:^{
            
        }];
        return;
    }
    //判断电话号码是否都是数字
    NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_phoneTextField.text.length<11||[_phoneTextField.text rangeOfCharacterFromSet:notDigits].location!=NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效手机号" andTitle:nil onView:self onCompletion:^{
            
        }];
    }
    if(_pwdTextField.text.length<6||_pwdTextField.text.length>18){
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6到18位之间" andTitle:nil onView:self onCompletion:^{
            
        }];
        return;
    }
    if (![_pwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入" andTitle:nil onView:self onCompletion:^{
            _pwdTextField.text = @"";
            _confirmPwdTextField.text = @"";
            
        }];
        return;
    }
    [self signUpRequest];
}
-(void)signUpRequest{
    _avi=[Utilities getCoverOnView:self.view];
    NSDictionary *para=@{@"tel":_phoneTextField.text,@"pwd":_pwdTextField.text};
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"%@",responseObject);
        if([responseObject[@"result"] integerValue] == 1){
            [Utilities popUpAlertViewWithMsg:@"注册成功" andTitle:nil onView:self onCompletion:^{
                [self performSegueWithIdentifier:@"signUpToLogin" sender:self];
            }];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:nil];
        }
        

    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        NSLog(@"%ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络参数" andTitle:nil onView:self onCompletion:nil];

    }];
}
@end
