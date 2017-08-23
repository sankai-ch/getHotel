//
//  HotelTableViewCell.h
//  GetHotels
//
//  Created by ll on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *hotelLocation;
@property (weak, nonatomic) IBOutlet UILabel *hotelDistance;
@property (weak, nonatomic) IBOutlet UILabel *hotelPrice;

@end
