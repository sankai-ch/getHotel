//
//  HotelOrderTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkIntime;
@property (weak, nonatomic) IBOutlet UILabel *checkOutTime;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;

@end
