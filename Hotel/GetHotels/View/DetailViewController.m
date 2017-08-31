//
//  DetailViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "DetailViewController.h"
#import "zhifuViewController.h"
@interface DetailViewController ()<UIScrollViewDelegate>
{
    NSInteger Flag;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIDatePicker *time;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cencer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirm;
@property (weak, nonatomic) IBOutlet UIImageView *imaget;
@property (weak, nonatomic) IBOutlet UILabel *bed1;

@property (weak, nonatomic) IBOutlet UILabel *bed2;
@property (weak, nonatomic) IBOutlet UILabel *bed3;



@property (weak, nonatomic) IBOutlet UILabel *jiudian;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *hotelbed;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UIButton *tidu;
- (IBAction)dituAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *timeday;
@property (weak, nonatomic) IBOutlet UIButton *timeday1;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *weiliao;
@property (weak, nonatomic) IBOutlet UIButton *goumai;
- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)concer:(UIBarButtonItem *)sender;
- (IBAction)confirm:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *yingc;
@property (strong,nonatomic )IBOutlet UIPageControl *page;
@property (strong ,nonatomic) IBOutlet NSTimer *tr;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self request];
    [self getimage];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTime];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tr invalidate];
    _tr = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollview
-(void)getimage{
    CGSize scrollSize = _scroll.frame.size;
    for(int i =0;i<4;i++)
    {
        UIImageView *imageview = [[UIImageView alloc]init];
        
        //CGFloat scrollWidth = scrollSize.width;
        CGFloat imagex = [[UIScreen mainScreen] bounds].size.width * i;
        CGFloat imagey = 0;
        CGFloat imagew = [[UIScreen mainScreen] bounds].size.width;
        CGFloat imageh = scrollSize.height;
        imageview.frame = CGRectMake(imagex, imagey, imagew, imageh);
        NSString *imagestr = [NSString stringWithFormat:@"1%d",i+1];
        imageview.image = [UIImage imageNamed:imagestr];
        [_scroll addSubview:imageview];
    }
    _scroll.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 4, 0);
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.backgroundColor = [UIColor grayColor];
    _scroll.delegate = self;
    _page = [[UIPageControl alloc] init];
    _page.frame = CGRectMake(_scrollView2.frame.size.width - 40,_scrollView2.frame.origin.y +130, 30, 10);
    _page.numberOfPages = 4;
    _page.pageIndicatorTintColor = [UIColor redColor];
    _page.currentPageIndicatorTintColor = [UIColor blueColor];
    [_scrollView2  addSubview:_page];
}
-(void)startTime{
    
    _tr = [NSTimer scheduledTimerWithTimeInterval: 1.5 target: self selector:@selector(nextpage)userInfo:nil repeats:YES];
}
-(void)nextpage{
    NSInteger page1 = self.page.currentPage;
    NSInteger nextpage = 0;
    if(page1 == self.page.numberOfPages - 1)
    {
        nextpage = 0;
    }else{
        nextpage = page1 +1;
    }
    
  CGFloat content = nextpage *_scroll.frame.size.width;
    _scroll.contentOffset = CGPointMake(content, 0);
   //[_scroll scrollRectToVisible:CGRectMake(UI_SCREEN_W * nextpage, 0, UI_SCREEN_W, 150) animated:YES];
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    if (scrollView == _scroll) {
        [_tr setFireDate:[NSDate distantFuture]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == _scroll) {
        [_tr setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scroll) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        //    NSLog(@"%d", page);
        // 设置页码
        _page.currentPage = page;
    }
}



//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"酒店预订";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 236);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//设置默认时间
- (void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    //将日期转换为字符串
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr = [formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    [_timeday setTitle:dateStr forState:UIControlStateNormal];
    [_timeday1 setTitle:dateTomStr forState:UIControlStateNormal];
}




#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 zhifuViewController *pay = [segue destinationViewController];
 
 pay.dict = sender;
 
 }
#pragma mark - button
- (IBAction)dituAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [self performSegueWithIdentifier:@"ditu" sender:nil];
    _yingc.hidden = YES;
}


- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck])
    {
        
        NSDictionary * dic = @{@1:_jiudian.text,@2:_timeday.titleLabel.text,@3:_timeday1.titleLabel.text,@4:_price.text};
        [self performSegueWithIdentifier:@"zhifu" sender:dic];
        //zhifuViewController *zhifu = [[zhifuViewController alloc]init];
        
        
    }else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
_yingc.hidden = YES;

}

- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    Flag = 0;
    _yingc.hidden = NO;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    Flag = 1;
    _yingc.hidden = NO;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)concer:(UIBarButtonItem *)sender {
    _toolbar.hidden = YES;
    _time.hidden = YES;
    _yingc.hidden = YES;
}

- (IBAction)confirm:(UIBarButtonItem *)sender {
    //拿到当前datePicker选择时间
    NSDate *date = _time.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter =[NSDateFormatter new];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd";
    //将日期转换为字符串
    NSString *theDate = [formatter stringFromDate:date];
    if(Flag == 0){
        [_timeday setTitle:theDate forState:UIControlStateNormal];
    }else{
        [_timeday1 setTitle:theDate forState:UIControlStateNormal];
    }
    _toolbar.hidden = YES;
    _time.hidden = YES;
    _yingc.hidden =YES;
}
- (void)request{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
    NSDictionary * para = @{@"id":[[StorageMgr singletonStorageMgr] objectForKey:@"hotelId"]};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"hotel:%@",responseObject);
        if([responseObject[@"result"]integerValue]==1){
            NSDictionary *result = responseObject[@"content"];
            detailModel *detail = [[detailModel alloc]initWithDict:result];

            NSString *tday =[[[StorageMgr singletonStorageMgr] objectForKey:@"customInTime"] substringFromIndex:2 ];
              NSString *tday1 =[[[StorageMgr singletonStorageMgr]objectForKey:@"customOutTime"] substringFromIndex:2 ];
            [_timeday setTitle:tday forState:(UIControlStateNormal)];
            [_timeday1 setTitle:tday1 forState:UIControlStateNormal];
        
            _jiudian.text =detail.hotels;
            _dizhi.text = detail.address;
            _price.text = [NSString stringWithFormat:@"¥ %ld",(long)detail.price];
            [_image3 sd_setImageWithURL:[NSURL URLWithString:detail.image] placeholderImage:[UIImage imageNamed:@"11"]];
            //_hotelbed.text = detail.type;
            NSArray *list = result[@"hotel_types"];
            for(int i=0;i<list.count;i++){
            switch (i) {
                    case 0:
                         _hotelbed.text= list[i];
                        break;
                    case 1:
                       _bed1.text = list[i];
                        break;
                    case 2:
                        _bed2.text = list[i];
                        break;
                    case 3:
                        _bed3.text = list[i];
                        break;
                        
                    default:
                        break;
                }
            }
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
           [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
               
           }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误,请稍后再试!" andTitle:@"提示" onView:self onCompletion:^{
            
        }];
    }];
}

@end
