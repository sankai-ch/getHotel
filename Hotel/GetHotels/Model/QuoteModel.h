//
//  QuoteModel.h
//  GetHotels
//
//  Created by admin1 on 2017/9/14.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuoteModel : NSObject

@property(strong,nonatomic) NSString * aviation_cabin;//舱位等级
@property(strong,nonatomic) NSString * aviation_company;//航空公司
@property(strong,nonatomic) NSString * departure;//出发地点
@property(strong,nonatomic) NSString * destination;//到达地点
@property(strong,nonatomic) NSString * flight_no;//航班号
@property(nonatomic) NSInteger final_price;//价格
@property(strong,nonatomic) NSString * in_time_str;//出发日期
@property(strong,nonatomic) NSString * out_time_str;//到达日期

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
