//
//  WeatherModel.h
//  GetHotels
//
//  Created by ll on 2017/9/11.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (strong, nonatomic) NSString *WeatherDes;
@property (strong, nonatomic) NSString *icon;
@property (nonatomic) NSInteger temp;

- (instancetype)initWithTemp:(NSDictionary *)dict;
- (instancetype)initWithimg:(NSDictionary *)dict;
@end
