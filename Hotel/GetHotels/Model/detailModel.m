//
//  detailModel.m
//  GetHotels
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "detailModel.h"

@implementation detailModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        self.hotels = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"无"];
     self.address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"无"];
         self.image = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@"无"];
        self.price=[[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0]integerValue];
         self.type = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@"无"];
       self.latitude=[Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@"无"];
       self.longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@"无"];
        
    }
    return self;
}
@end
