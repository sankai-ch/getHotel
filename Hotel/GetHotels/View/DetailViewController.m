//
//  DetailViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate>
{
    NSInteger Flag;
}
@property (weak, nonatomic) IBOutlet UIImageView *p4;
@property (weak, nonatomic) IBOutlet UIImageView *p3;
@property (weak, nonatomic) IBOutlet UIImageView *p2;
@property (weak, nonatomic) IBOutlet UIImageView *p1;
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
@property (strong,nonatomic) NSTimer *timer;
- (IBAction)weiiaoAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)concer:(UIBarButtonItem *)sender;
- (IBAction)confirm:(UIBarButtonItem *)sender;
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
- (void)viewWillDisappear:(BOOL)animated {
    [self viewWillDisappear:YES];
    [_tr invalidate];
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
    self.scroll.delegate = self;
    _page = [[UIPageControl alloc] init];
    _page.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 + 150, [[UIScreen mainScreen] bounds].size.height/6 +80, 10, 10);
    _page.numberOfPages = 4;
    _page.pageIndicatorTintColor = [UIColor redColor];
    _page.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:_page];
    [self startTime];
}
-(void)startTime{
    
    self.tr = [NSTimer timerWithTimeInterval: 2.0 target: self selector:@selector(nextpage)userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.tr forMode:NSRunLoopCommonModes];
}
-(void)nextpage{
    NSInteger page1 = self.page.currentPage;
    NSLog(@"%ld",(long)page1);
    NSInteger nextpage = 0;
    if(page1 == self.page.numberOfPages - 1)
    {
        nextpage = 0;
    }else{
        nextpage = page1 +1;
    }
    
    CGFloat content = nextpage *_scroll.frame.size.width;
    _scroll.contentOffset = CGPointMake(content, 0);
    
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_tr invalidate];
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.tr = [NSTimer timerWithTimeInterval: 2.0 target: self selector:@selector(nextpage)userInfo:nil repeats:YES];
    [self startTime];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    // 设置页码
    _page.currentPage = page;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - button
- (IBAction)dituAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [self performSegueWithIdentifier:@"ditu" sender:nil];
}
- (IBAction)weiiaoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"weiliao" sender:nil];
}

- (IBAction)goumaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"zhifu" sender:nil];

}

- (IBAction)dayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    Flag = 0;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)day1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    Flag = 1;
    _toolbar.hidden = NO;
    _time.hidden = NO;
}

- (IBAction)concer:(UIBarButtonItem *)sender {
    _toolbar.hidden = YES;
    _time.hidden = YES;
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
}
- (void)request{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
    NSDictionary * para = @{@"id":@1};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"hotel:%@",responseObject);
        if([responseObject[@"result"]integerValue]==1){
            NSDictionary *result = responseObject[@"content"];
            detailModel *detail = [[detailModel alloc]initWithDict:result];
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
