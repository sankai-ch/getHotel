//
//  LoginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)loginBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginBtn.enabled = NO;
    _loginBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    // Do any additional setup after loading the view.
    //添加事件，监听当输入框的内容改变时调用textChange的方法
    [_phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self naviConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当textField结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _phoneTextField || textField == _pwdTextField){
        //当用户名和密码都输入后，按钮才能被点击
        if(_phoneTextField.text.length != 0 && _pwdTextField.text.length !=0){
            _loginBtn.enabled = YES;
        }
    }
    
}

//输入框内容改变的监听事件
- (void)textChange:(UITextField *)textField{
    //当文本框中的内容改变时判断内容长度是否为0，是：启用按钮，否：禁用按钮
    if(_phoneTextField.text.length != 0 && _pwdTextField.text.length != 0){
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor = UIColorFromRGB(99, 163, 210);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(153, 153, 153);
    }
}



- (void)setShadow {
    
    _shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _shadowImageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shadowImageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _shadowImageView.layer.shadowRadius = 4;//阴影半径，默认3
}

//设置导航栏样式
- (void)naviConfig{
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}

//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _phoneTextField || textField == _pwdTextField){
        [textField resignFirstResponder];
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)loginBtn:(UIButton *)sender {
    if(_phoneTextField.text.length==0 ||_phoneTextField.text.length<11){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号" andTitle:nil onView:self onCompletion:^{
            
        }];
        return;
    }
    if(_pwdTextField.text.length==0)
    {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self onCompletion:^{
            
        }];
        return;
    }
    if(_pwdTextField.text.length<6||_pwdTextField.text.length>18){
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6到18位之间" andTitle:nil onView:self onCompletion:^{
            
        }];
        return;
    }
    //判断电话号码是否都是数字
    NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_phoneTextField.text.length<11||[_phoneTextField.text rangeOfCharacterFromSet:notDigits].location!=NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效手机号" andTitle:nil onView:self onCompletion:^{
            
        }];
    }
    //确认无误后，执行网络请求
    
}
#pragma mark - request
-(void)signInRequest{
    NSDictionary *para=@{@"tel":_phoneTextField.text};
}
@end
