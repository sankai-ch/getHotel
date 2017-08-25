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

@property (strong, nonatomic) NSMutableArray *cityListArr;
@property (strong, nonatomic) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityListArr = [NSMutableArray new];
    _arr = [NSMutableArray new];
    [self naviConfig];
    [self requestCity];
    // Do any additional setup after loading the view.
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

//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
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
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetHome" object:cityListModel.cityArr[indexPath.row]] waitUntilDone:YES];
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

#pragma mark - searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self requestCity];
        return;
    }
    [self requestOfFindCity:searchText];
}



#pragma mark - request
- (void)requestCity {
    [RequestAPI requestURL:@"/findCity" withParameters:@{@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            [_arr removeAllObjects];
            for (NSDictionary *dict in content) {
                CityListModel *cityList = [[CityListModel alloc] initWithDict:dict];
                [_cityListArr addObject:cityList];
                [_arr addObject:cityList.tip];
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
        NSLog(@"%@",responseObject);
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

@end
