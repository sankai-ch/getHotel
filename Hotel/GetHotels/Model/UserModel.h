//
//  UserModel.h
//  GetHotels
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic)NSInteger state;

@property(strong,nonatomic)NSString *gender;

@property(nonatomic)NSInteger grade;

@property(strong,nonatomic)NSString  *headImg;

@property(strong,nonatomic)NSString *userId;

@property(strong,nonatomic)NSString *idCard;

@property(strong,nonatomic)NSString *nickName;

@property(strong,nonatomic)NSString *openId;

@property(strong,nonatomic)NSString *realName;

@property(strong,nonatomic)NSString *startTime;

@property(strong,nonatomic)NSString *startTimeStr;

@property(strong,nonatomic)NSString *Tel;

- (instancetype) initWhitDictionary: (NSDictionary *)dict;
@end
