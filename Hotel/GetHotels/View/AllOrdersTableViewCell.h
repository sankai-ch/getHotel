//
//  AllOrdersTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLAbel;

@property (weak, nonatomic) IBOutlet UILabel *hotelPeopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImg;


@end
