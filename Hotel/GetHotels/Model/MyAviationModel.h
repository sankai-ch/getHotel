//
//  MyAviationModel.h
//  GetHotels
//
//  Created by ll on 2017/9/7.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAviationModel : NSObject
@property (strong, nonatomic) NSString *startTime;
//@property (strong, nonatomic) NSString *departure;
//@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSString *aviationDemandTitle;
@property (nonatomic) NSInteger lowPrice;
@property (nonatomic) NSInteger highPrice;
@property (strong, nonatomic) NSString *aviationDemandDetail;
@property (strong, nonatomic) NSString *timeRequest;
@property (nonatomic) NSInteger Id;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
