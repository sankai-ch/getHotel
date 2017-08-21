//
//  RequestAPI.m
//  Request
//
//  Created by ZIYAO YANG on 24/11/2015.
//  Copyright © 2015 Pro. All rights reserved.
//

#import "RequestAPI.h"
#import "Constants.h"

@implementation RequestAPI

+ (void)requestURL:(NSString *)request withParameters:(NSDictionary *)parameter andHeader:(NSArray *)headers byMethod:(NSInteger)method andSerializer:(NSInteger)serializer success:(void (^)(id responseObject))success failure:(void (^)(NSInteger statusCode, NSError *error))failure {
    NSString *server = kServer;
    NSString *url = [NSString stringWithFormat:@"%@%@", server, request];
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AppAPIClient *manager = nil;
    switch (serializer) {
        case 1:
            manager = [AppAPIClient sharedJSONClient];
            break;
        case 2:
            manager = [AppAPIClient sharedResponseDataClient];
            break;
        default:
            manager = [AppAPIClient sharedClient];
            break;
    }
    for (NSDictionary *header in headers) {
        [manager.requestSerializer setValue:header[@"value"] forHTTPHeaderField:header[@"key"]];
    }
    switch (method) {
        case 1: {
            [manager POST:decodedURL parameters:parameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                success(responseObject);
            } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                failure(httpResponse.statusCode, error);
            }];
        }
            break;
        case 2: {
            [manager PUT:decodedURL parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                failure(httpResponse.statusCode, error);
            }];
        }
            break;
        case 3: {
            [manager DELETE:decodedURL parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                failure(httpResponse.statusCode, error);
            }];
        }
            break;
        default: {
            [manager GET:decodedURL parameters:parameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                success(responseObject);
            } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                failure(httpResponse.statusCode, error);
            }];
        }
            break;
    }
}

@end
