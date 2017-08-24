//
//  AAndHModel.m
//  GetHotels
//
//  Created by ll on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "AAndHModel.h"

@implementation AAndHModel

- (instancetype)initWithDictForHotelCell:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"暂无"];
        self.cityId = [[Utilities nullAndNilCheck:dict[@"city_id"] replaceBy:0] integerValue];
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        self.hotelPrice = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"未知"];
        self.hotelImg = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
    }
    return self;
}


@end
