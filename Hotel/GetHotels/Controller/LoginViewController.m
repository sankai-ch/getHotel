//
//  LoginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
- (IBAction)loginBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

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
    //同上，密码框的监听
    [_pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    //设置导航条
    [self naviConfig];
    //记忆用户名，让下一次登录可以不用再次输入用户名
    [self uiLayout];
    //设置阴影
    [self setShadow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uiLayout{
    _avatar.layer.borderColor = [UIColor colorWithRed:202/255.0f green:224/255.0f blue:251/255.0f alpha:1].CGColor;
    if(![[Utilities getUserDefaults:@"UserTel"] isKindOfClass:[NSNull class]]){
        if([Utilities getUserDefaults:@"UserTel"]!=nil){
            _phoneTextField.text=[Utilities getUserDefaults:@"UserTel"];
        }
    }

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
    self.navigationItem.title = @"会员登录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
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
    [self signInRequest];
}
#pragma mark - request
-(void)signInRequest{
    _avi=[Utilities getCoverOnView:self.view];
    NSDictionary *para=@{@"tel":_phoneTextField.text,@"pwd":_pwdTextField.text};
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        if([responseObject[@"result"] integerValue]==1){
            NSLog(@"%@",responseObject[@"content"]);
            NSDictionary *result=responseObject[@"content"];
            UserModel *user=[[UserModel alloc]initWhitDictionary:result];
            [[StorageMgr singletonStorageMgr]addKey:@"UserInfo" andValue:user];
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:user.userId];
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"OpenId"];
            [[StorageMgr singletonStorageMgr] addKey:@"OpenId" andValue:user.openId];
            [self.view endEditing:YES];
            _pwdTextField.text=@"";
            [Utilities setUserDefaults:@"UserTel" content:_phoneTextField.text];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:@"密码错误！" andTitle:@"警报" onView:self onCompletion:^{
                
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        NSLog(@"%ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试!" andTitle:@"提示" onView:self onCompletion:^{
            
        }];

    }];
}
@end
