//
//  WeatherModel.m
//  GetHotels
//
//  Created by ll on 2017/9/11.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (instancetype)initWithTemp:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.temp = [[Utilities nullAndNilCheck:dict[@"temp"] replaceBy:0] integerValue];
    }
    return self;
}

- (instancetype)initWithimg:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.icon = [Utilities nullAndNilCheck:dict[@"icon"] replaceBy:@""];
        self.WeatherDes = [Utilities nullAndNilCheck:dict[@"description"] replaceBy:@"小雨"];
    }
    return self;
}
@end
