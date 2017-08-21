//
//  RequestAPI.h
//  Request
//
//  Created by ZIYAO YANG on 24/11/2015.
//  Copyright © 2015 Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAPIClient.h"

typedef NS_ENUM (NSInteger, NetworkRequestMethod) {
    kGet = 0,
    kPost,
    kPut,
    kDelete
};

typedef NS_ENUM (NSInteger, NetworkRequestSerializer) {
    kForm = 0,
    kJson,
    kRes
};

@interface RequestAPI : NSObject

+ (void)requestURL:(NSString *)request withParameters:(NSDictionary *)parameter andHeader:(NSArray *)headers byMethod:(NSInteger)method andSerializer:(NSInteger)serializer success:(void (^)(id responseObject))success failure:(void (^)(NSInteger statusCode, NSError *error))failure;

@end
