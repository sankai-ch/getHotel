//
//  QuoteModel.m
//  GetHotels
//
//  Created by admin1 on 2017/9/14.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "QuoteModel.h"

@implementation QuoteModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.aviation_cabin = [Utilities nullAndNilCheck:dict[@"aviation_cabin"] replaceBy:@""];
        self.aviation_company = [Utilities nullAndNilCheck:dict[@"aviation_company"] replaceBy:@""];
        self.departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"暂无"];
        self.destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"无"];
        self.flight_no = [Utilities nullAndNilCheck:dict[@"flight_no"] replaceBy:@"1"];
        self.final_price = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:0 ]integerValue];
        self.in_time = [Utilities nullAndNilCheck:dict[@"in_time"] replaceBy:@"1"];
        
        self.out_time = [Utilities nullAndNilCheck:dict[@"out_time"] replaceBy:@""];
    }
    return self;
}

@end
