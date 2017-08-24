//
//  AAndHModel.h
//  GetHotels
//
//  Created by ll on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAndHModel : NSObject
@property (strong, nonatomic) NSString *adImg; //广告图片
@property (strong, nonatomic) NSString *adName; //名字
@property (strong, nonatomic) NSString *adUrl;
@property (nonatomic) NSInteger adId;
@property (strong, nonatomic) NSString *adStaTime;


@property (nonatomic) NSInteger hotelBId;//
@property (strong, nonatomic) NSString *hotelAdd;
@property (strong, nonatomic) NSString *distance;//距离
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelPrice;
@property (strong, nonatomic) NSString *hotelImg;
@property (nonatomic) NSInteger cityId;

- (instancetype)initWithDictForHotelCell: (NSDictionary *)dict;
- (instancetype)initWithDictForAD: (NSDictionary *)dict;

@end
