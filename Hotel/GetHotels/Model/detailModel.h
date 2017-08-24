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
@property (nonatomic) NSInteger price;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
