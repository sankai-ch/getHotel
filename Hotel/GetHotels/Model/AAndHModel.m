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
        self.hotelAdd = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"未知"];
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        self.hotelPrice = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"未知"];
        self.hotelImg = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
    }
    return self;
}


- (instancetype)initWithDictForAD:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.adName = [Utilities nullAndNilCheck:dict[@"ad_name"] replaceBy:@"暂无"];
        self.adImg = [Utilities nullAndNilCheck:dict[@"ad_img"] replaceBy:@""];
        self.adUrl = [Utilities nullAndNilCheck:dict[@"ad_url"] replaceBy:@""];
        self.adId = [[Utilities nullAndNilCheck:@"id" replaceBy:@""] integerValue];
    }
    return self;
}

@end
