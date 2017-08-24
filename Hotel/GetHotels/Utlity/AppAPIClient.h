//
//  appAPIClient.h
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AppAPIClient : AFHTTPSessionManager

//匹配阿里云默认配置
+ (instancetype)sharedClient;
//搞事情的人会用的配置（比如微信）
+ (instancetype)sharedResponseDataClient;
//大部分有一些后端开发底子的人会使用的配置
+ (instancetype)sharedJSONClient;

@end
