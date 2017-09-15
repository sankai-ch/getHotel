//
//  HotelOrdersModel.m
//  GetHotels
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "HotelOrdersModel.h"

@implementation HotelOrdersModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        self.hotelType = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@""];
        self.area = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
        self.remark = [Utilities nullAndNilCheck:dict[@"remark"] replaceBy:@"暂无"];
        self.checkInTime = [Utilities nullAndNilCheck:dict[@"final_in_time_str"] replaceBy:@""];
        self.checkOutTime = [Utilities nullAndNilCheck:dict[@"final_out_time_str"] replaceBy:@""];
        
    }
    return self;
}

@end
