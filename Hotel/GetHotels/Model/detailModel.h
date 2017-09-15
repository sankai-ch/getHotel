//
//  detailModel.h
//  GetHotels
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject
@property (strong,nonatomic) NSString *hotels;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *image;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *longitude;

@property (nonatomic) NSInteger price;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
