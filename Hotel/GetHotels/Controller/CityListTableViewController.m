//
//  CityListTableViewController.m
//  GetHotels
//
//  Created by ll on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "CityListTableViewController.h"
#import "CityListModel.h"
#import "HotelViewController.h"
@interface CityListTableViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *cityListTableView;
@property (strong, nonatomic) NSMutableArray *cityListArr;
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation CityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityListArr = [NSMutableArray new];
    _arr = [NSMutableArray new];
    [self requestCiry];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    return _arr;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    HotelViewController *hotelVC = segue.destinationViewController;
//    [hotelVC.cityLocation setTitle:sender forState:UIControlStateNormal];
//}

#pragma mark - request
- (void)requestCiry {
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
            [_cityListTableView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
@end
