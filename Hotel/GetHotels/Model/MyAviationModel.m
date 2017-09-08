//
//  MyAviationModel.m
//  GetHotels
//
//  Created by ll on 2017/9/7.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyAviationModel.h"

@implementation MyAviationModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.aviationDemandTitle = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        self.Id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue];
        self.startTime = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@"暂无"];
        self.aviationDemandDetail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@"无"];
        self.lowPrice = [[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:0] integerValue];
        self.highPrice = [[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:0] integerValue];
        self.requestMark = [Utilities nullAndNilCheck:dict[@""] replaceBy:@"暂无"];
    }
    return self;
}


@end
