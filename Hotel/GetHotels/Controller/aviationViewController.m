//
//  aviationViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "aviationViewController.h"
#import "CityListViewController.h"
@interface aviationViewController ()
{
    NSInteger i;
    NSInteger j;
}
@property (weak, nonatomic) IBOutlet UIView *xiugaitu;
@property (weak, nonatomic) IBOutlet UIView *function;
@property (weak, nonatomic) IBOutlet UIButton *strattime;
@property (weak, nonatomic) IBOutlet UIButton *endtime;
@property (weak, nonatomic) IBOutlet UIButton *fromcity;
@property (weak, nonatomic) IBOutlet UIButton *gocity;
@property (weak, nonatomic) IBOutlet UITextField *stactprice;
@property (weak, nonatomic) IBOutlet UITextField *endprice;
@property (weak, nonatomic) IBOutlet UITextField *objectiv;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UIButton *issued;
- (IBAction)issuedAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *hiddendate;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *canner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confrim;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)connerAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIView *hdview;
- (IBAction)confrimAction:(UIBarButtonItem *)sender;

- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)formcityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)gocity:(UIButton *)sender forEvent:(UIEvent *)event;
@property(strong,nonatomic)NSString *start;
@property(strong,nonatomic)NSString *end;


@end

@implementation aviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    // Do any additional setup after loading the view.
    [self setDefaultDateForButton];
    [self backclor];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hdAction)];
    
   
    [_hdview addGestureRecognizer:tap];
   
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Tag"];
    [[StorageMgr singletonStorageMgr] addKey:@"Tag" andValue:@2];
      NSString *userCity = [Utilities getUserDefaults:@"usercity"];
    [_fromcity setTitle:userCity forState:UIControlStateNormal];
    NSString *goCity = [Utilities getUserDefaults:@"gocity"];
    [_gocity setTitle:goCity forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"fly" object:nil];
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillSh:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHi:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)keyboardWillSh:(NSNotification *)note
{
    //CGRect keyboardReck = [[object.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.view.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
 
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
    //_function.frame = CGRectMake(_function.frame.origin.x,0, _function.frame.size.width, _function.frame.size.height);
 
}
-(void)keyboardWillHi:(NSNotification *)note
{
    //CGRect keyboardReck = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    //_function.frame =CGRectMake(_function.frame.origin.x, _function.frame.origin.y, _function.frame.size.width, _function.frame.size.height);
   
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收回键盘的目的
    [self.view endEditing:YES];
}

-(void)backclor{
   
    _xiugaitu.layer.borderColor = [UIColor colorWithRed:202/255.0f green:224/255.0f blue:251/255.0f alpha:1].CGColor;
    _xiugaitu.layer.borderWidth = 2.0f;
    _function.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _function.layer.shadowOffset = CGSizeMake(0, 0);
    _function.layer.shadowOpacity= 0.7f;
    _function.layer.shadowRadius = 4.0f;
    _stactprice.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _stactprice.layer.borderWidth = 1.0;
    _stactprice.layer.cornerRadius=5.0;
    _endprice.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _endprice.layer.borderWidth = 1.0;
    _endprice.layer.cornerRadius =5.0;

}
-(void)hdAction{
    _hdview.hidden = YES;
    _hiddendate.hidden = YES;
    _date.hidden = YES;
    
    _toolbar.hidden  = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}



- (void)checkCityState: (NSNotification *)note {
    
    NSString *cityStr = note.object;
    if(j == 0)
    {
    if (![_fromcity.titleLabel.text isEqualToString:cityStr]) {
        //修改城市按钮标题
        [_fromcity setTitle:cityStr forState:UIControlStateNormal];
        //删除记忆体
        [Utilities removeUserDefaults:@"usercity"];
        //添加记忆体
        [Utilities setUserDefaults:@"usercity" content:cityStr];
    }
    }else{
        if (![_gocity.titleLabel.text isEqualToString:cityStr]) {
            //修改城市按钮标题
            [_gocity setTitle:cityStr forState:UIControlStateNormal];
            //删除记忆体
            [Utilities removeUserDefaults:@"gocity"];
            //添加记忆体
            [Utilities setUserDefaults:@"gocity" content:cityStr];
            
        }
    }
}
//设置导航栏样式
//设置导航栏样式

//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"航空发布";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //实例化一个button 类型为UIButtonTypeSystem
    //UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    //将日期转换为字符串
    _start = [formatter stringFromDate:date];
     _end = [formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    NSString *dateStr = [_start substringFromIndex:5];
     NSString *dateTomStr = [_end substringFromIndex:5];
    [_strattime setTitle:dateStr forState:UIControlStateNormal];
    [_endtime setTitle:dateTomStr forState:UIControlStateNormal];
}
- (IBAction)issuedAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        
        if([_fromcity.titleLabel.text isEqualToString:_gocity.titleLabel.text]||[_gocity.titleLabel.text isEqualToString:@"请选择城市"]){
            [Utilities popUpAlertViewWithMsg:@"你选中的城市有误,请重新输入" andTitle:@"提示" onView:self onCompletion:^{
                
            }];
        }else{
            if([_stactprice.text isEqualToString:@"" ] || [_endprice.text isEqualToString:@""]){
                [Utilities popUpAlertViewWithMsg:@"请输入正确的价格,请重新输入" andTitle:@"提示" onView:self onCompletion:^{
                    
                }];
                
                
            }else{
                              if( [_stactprice.text integerValue] >=  [_endprice.text integerValue]){
                    [Utilities popUpAlertViewWithMsg:@"您输入的起始价格不能大于最终价格,请重新输入" andTitle:@"提示" onView:self onCompletion:^{
                        
                    }];
                }else{
                    if([_objectiv.text isEqualToString:@""]){
                        [Utilities popUpAlertViewWithMsg:@"标题不能为空，请重新输入" andTitle:nil onView:self onCompletion:^{
                            
                        }];
                    }else{
                        [self request];
                    }

                }
            }
            
        }
        
    }
    else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
      
    
}
- (IBAction)connerAction:(UIBarButtonItem *)sender {
     _hdview.hidden = YES;
     _hiddendate.hidden = YES;
    _date.hidden = YES;
    _toolbar.hidden  = YES;
    
}

- (IBAction)confrimAction:(UIBarButtonItem *)sender {
       //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = _date.date;
    //将日期转换为字符串
    NSDate* dates = [NSDate date];
    NSTimeInterval a =[dates timeIntervalSince1970] - 86400;
    NSTimeInterval b =[date timeIntervalSince1970];
    //NSTimeInterval c =[date timeIntervalSince1970];
    
    /////////
  
        if(i == 0) {
            if(b > a){
                  _start = [formatter stringFromDate:date];
                NSTimeInterval c = [Utilities cTimestampFromString:_start format:@"yyyy-MM-dd"];
                NSTimeInterval d = [Utilities cTimestampFromString:_end format:@"yyyy-MM-dd"];
                if(c <= d){
                    NSString *dateStr = [_start substringFromIndex:5];
                    
                    [_strattime setTitle:dateStr forState:UIControlStateNormal];
                } else{
                    [Utilities popUpAlertViewWithMsg:@"你输入的时间不能大于到达时间，请重新输入" andTitle:nil onView:self onCompletion:^{
                        
                    }];
                }
            }
            else{
                [Utilities popUpAlertViewWithMsg:@"你输入的时间有误，请重新输入" andTitle:nil onView:self onCompletion:^{
                    
                }];
            }
        }
        if (i == 1){
            if(b > a){
                _end = [formatter stringFromDate:date];
                NSTimeInterval c = [Utilities cTimestampFromString:_start format:@"yyyy-MM-dd"];
                NSTimeInterval d = [Utilities cTimestampFromString:_end format:@"yyyy-MM-dd"];
                if( c<=d ){
                    NSString *dateTomStr = [_end substringFromIndex:5];
                     [_endtime setTitle:dateTomStr forState:UIControlStateNormal];
                }
                else{
                    [Utilities popUpAlertViewWithMsg:@"你输入的时间小于开始时间，请重新输入" andTitle:nil onView:self onCompletion:^{
                        
                    }];
                }
            }else{
                [Utilities popUpAlertViewWithMsg:@"你输入的时间有误，请重新输入" andTitle:nil onView:self onCompletion:^{
                    
                }];
            }
            
            
    }
    // *1000 是精确到毫秒，不乘就是精确到秒
       _hdview.hidden = YES;
    _hiddendate.hidden = YES;
    _date.hidden = YES;
    
    _toolbar.hidden  = YES;
}


- (IBAction)stratTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    i =0;
     _hdview.hidden = NO;
     _hiddendate.hidden = NO;
    _date.hidden = NO;
   
    _toolbar.hidden  = NO;
}

- (IBAction)endActon:(UIButton *)sender forEvent:(UIEvent *)event {
    i =1;
      _hdview.hidden = NO;
     _hiddendate.hidden = NO;
    _date.hidden = NO;
   
    _toolbar.hidden  = NO;
}


//初始城市
- (IBAction)formcityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    j=0;
 
    CityListViewController *vc = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"flypath"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
     [self presentViewController:nc animated:YES completion:nil];
    //[self dell];
}

//到达城市
- (IBAction)gocity:(UIButton *)sender forEvent:(UIEvent *)event {
    j=1;
        CityListViewController *vc = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"flypath"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
-(void)request{

    NSString *arr = [[StorageMgr singletonStorageMgr]objectForKey:@"OpenId"];
    NSLog(@"openId = %@", arr);
    NSDictionary *para = @{@"openid":arr,@"aviation_demand_title":_objectiv.text,@"set_low_time_str":_start,@"set_high_time_str":_end,@"set_hour":@"20",@"departure":_fromcity.titleLabel.text,@"destination":_gocity.titleLabel.text,@"low_price":_stactprice.text,@"high_price":_endprice.text,@"aviation_demand_detail":_detail.text,@"is_back":@5,@"back_low_time_str":@"无",@"back_high_time_str":@"无",@"people_number":@3,@"child_number":@1,@"weight":@50.0};
    NSLog(@"para = %@", para);
    [RequestAPI requestURL:@"/addIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"resprnse:%@",responseObject);
        if([responseObject[@"result"] integerValue] == 1)
        {
            [Utilities popUpAlertViewWithMsg:@"恭喜你发布成功，请注意接收消息☺" andTitle:nil onView:self onCompletion:^{
               
            }];
            _stactprice.text = @"";
            _endprice.text = @"";
            _detail.text =@"";
            _objectiv.text =@"";
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
                
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode = %ld", (long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误,请稍后再试!" andTitle:@"提示" onView:self onCompletion:^{
            
        }];
    }];
}
@end
