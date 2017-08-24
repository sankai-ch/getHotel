//
//  CityListModel.h
//  GetHotels
//
//  Created by ll on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityListModel : NSObject

@property (strong, nonatomic) NSString *tip;
@property (strong, nonatomic) NSMutableArray *cityArr;

- (instancetype)initWithDict: (NSDictionary *)dict;

@end
