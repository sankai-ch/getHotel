//
//  JSONS.h
//  JSON
//
//  Created by MengYa Wang on 15/1/19.
//  Copyright (c) 2015年 Juice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONS : NSObject

@end

@interface NSObject (JSONS)

- (NSData *)JSONDatainfo;
- (NSString *)JSONStr;

@end

@interface NSString(JSONS)

- (id)JSONCol;

@end

@interface NSData(JSONS)

- (id)JSONCol;

@end
