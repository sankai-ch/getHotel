//
//  zhifuModel.h
//  GetHotels
//
//  Created by admin1 on 2017/8/28.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zhifuModel : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *starttime;
@property (strong,nonatomic) NSString *endtime;
@property (nonatomic) NSInteger pirce;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
