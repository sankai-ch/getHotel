//
//  CityListViewController.m
//  GetHotels
//
//  Created by ll on 2017/8/25.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "CityListViewController.h"
#import "CityListModel.h"
#import "HotelViewController.h"
@interface CityListViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
- (IBAction)cancelAction;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelViewTralling;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *cityListArr;
@property (strong, nonatomic) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityListArr = [NSMutableArray new];
    _arr = [NSMutableArray new];
    _tableView.tableFooterView = [UIView new];
    [self naviConfig];
    //监听键盘将要打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘将要收起这一操作，打开后执行keyboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self requestCity];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"城市列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
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

//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _cityListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CityListModel *cityListModel = _cityListArr[section];
    return cityListModel.cityArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityListCell" forIndexPath:indexPath];
    CityListModel *cityListModel = _cityListArr[indexPath.section];
    cell.textLabel.text = cityListModel.cityArr[indexPath.row];
    // Configure the cell...
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CityListModel *cityListModel = _cityListArr[section];
    return cityListModel.tip;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityListModel *cityListModel = _cityListArr[indexPath.section];
    switch ([[[StorageMgr singletonStorageMgr] objectForKey:@"Tag"] integerValue]) {
        case 1:
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetHome" object:cityListModel.cityArr[indexPath.row]] waitUntilDone:YES];
            break;
            
        case 2:
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"fly" object:cityListModel.cityArr[indexPath.row]] waitUntilDone:YES];
            break;
    }
    //跳转
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //NSLog(@"-----------------------------%lu",(unsigned long)_arr.count);
    if (_arr.count !=23) {
        return 0;
    }
    return _arr;
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [_searchBar resignFirstResponder];
//}

#pragma mark - searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self requestCity];
        return;
    }
    [self requestOfFindCity:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _cancelViewTralling.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
        //self.view.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
}

#pragma mark - keyBorder



//键盘打开的时候操作
- (void)keyboardWillShow: (NSNotification *)notification {
    //获取键盘的位置
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    //计算键盘出现后，为保证_scrollView的内容都能显示，它应该滚动到y轴的位置
    //    CGFloat newOffset =(_tableView.contentSize.height - _tableView.frame.size.height) + keyboardRect.size.height;
    //    //将_scrollView滚动到上述位置
    //    [_tableView setContentOffset:CGPointMake(0, newOffset) animated:YES];
    //CGFloat viewFrame = _tableView.contentSize.height;
    _tableViewBottom.constant = keyboardRect.size.height;
    
}

- (void)keyboardWillHide: (NSNotification *)notification {
    //    //计算键盘出现后，为保证_scrollView的内容都能显示，它应该滚动到y轴的位置
    //    CGFloat newOffset =(_tableView.contentSize.height - _tableView.frame.size.height) + keyboardRect.size.height;
    //    //将_scrollView滚动到上述位置
    //    [_tableView setContentOffset:CGPointMake(0, newOffset) animated:YES];
    _tableViewBottom.constant = 0;
}


#pragma mark - request
- (void)requestCity {
    [RequestAPI requestURL:@"/findCity" withParameters:@{@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            [_arr removeAllObjects];
            [_cityListArr removeAllObjects];
            for (NSDictionary *dict in content) {
                CityListModel *cityList = [[CityListModel alloc] initWithDict:dict];
                [_cityListArr addObject:cityList];
                if ([cityList.tip isEqualToString:@"热门城市"]) {
                    [_arr addObject:@"热"];
                } else {
                    [_arr addObject:cityList.tip];
                }
            }
            //            CityListModel *cityList = _cityListArr[0];
            //            NSLog(@"%@",cityList.tip);
            //            NSLog(@"%lu",(unsigned long)cityList.cityArr.count);
            [_tableView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
- (void)requestOfFindCity: (NSString *)text {
    [RequestAPI requestURL:@"/getCityByName" withParameters:@{@"name":text,@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue]== 1) {
            NSArray *content = responseObject[@"content"];
            [_cityListArr removeAllObjects];
            [_arr removeAllObjects];
            for (NSDictionary *dict in content) {
                CityListModel *cityModel = [[CityListModel alloc] initWithDict:dict];
                [_cityListArr addObject:cityModel];
            }
            [_tableView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}


#pragma mark - btnAction


- (IBAction)cancelAction {
    [_searchBar resignFirstResponder];
    _cancelViewTralling.constant = -50;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end

