//
//  JSONS.m
//  JSON
//
//  Created by MengYa Wang on 15/1/19.
//  Copyright (c) 2015年 Juice. All rights reserved.
//

#import "JSONS.h"

@implementation JSONS

@end

@implementation NSObject (JSONS)

- (NSData *)JSONDatainfo {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        return jsonData;
    } else {
        return nil;
    }
}

- (NSString *)JSONStr {
    NSData *jsonData = [self JSONDatainfo];
    if ([jsonData length] > 0) {
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
        return jsonStr;
    } else {
        return nil;
    }
}

@end

@implementation NSString (JSONS)

- (id)JSONCol {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        return nil;
    }
}

@end

@implementation NSData (JSONS)

- (id)JSONCol {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        return nil;
    }
}

@end
