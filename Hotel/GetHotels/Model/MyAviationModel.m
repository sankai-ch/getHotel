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
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"start_time"] integerValue]];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"H";
        self.timeRequest = [formatter stringFromDate:date];
//        NSInteger time = [[formatter stringFromDate:date] integerValue];
//        if (time < 6) {
//            self.timeRequest = [NSString stringWithFormat:@"凌晨%ld",(long)time];
//        } else if (time < 9){
//            self.timeRequest = [NSString stringWithFormat:@"早上%ld",(long)time];
//        } else if (time < 11) {
//            self.timeRequest = [NSString stringWithFormat:@"上午%ld",(long)time];
//        } else if (time == 12) {
//            self.timeRequest = [NSString stringWithFormat:@"中午%ld",(long)time];
//        } else if (time < 18) {
//            self.timeRequest = [NSString stringWithFormat:@"凌晨%ld",(long)time];
//        } else if (time < 24){
//            self.timeRequest = [NSString stringWithFormat:@"凌晨%ld",(long)time];
//        }
        
    }
    return self;
}


@end
