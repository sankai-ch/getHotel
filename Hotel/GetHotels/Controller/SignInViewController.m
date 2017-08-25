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

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _signInBtn.enabled = NO;

    [self naviConfig];
    [self setShadow];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShadow {
    
    _shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _shadowImageView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
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
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    if ([_pwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        [self signUpRequest];
    }else{
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入" andTitle:@"提示" onView:self onCompletion:^{
            _pwdTextField.text = @"";
            _confirmPwdTextField.text = @"";
        }];
    }

}
-(void)signUpRequest{
    _avi=[Utilities getCoverOnView:self.view];
    NSDictionary *para=@{@"tel":_phoneTextField.text,@"pwd":_pwdTextField.text};
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"%@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        NSLog(@"%ld",(long)statusCode);
    }];
}
@end
