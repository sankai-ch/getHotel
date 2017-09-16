//
//  HotelOrdersModel.h
//  GetHotels
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelOrdersModel : NSObject
@property (strong,nonatomic) NSString *hotelName;
@property (strong,nonatomic) NSString *hotelType;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *checkInTime;
@property (strong, nonatomic) NSString *checkOutTime;

- (instancetype)initWithDict:(NSDictionary *)dict;


@end
