//
//  AllOrdersTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelDetailName;
@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *comeInNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;

@end
