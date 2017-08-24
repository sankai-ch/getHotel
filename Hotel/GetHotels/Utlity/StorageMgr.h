/********************************************************************
 File name  : storageMgr.h
 Editor     : Ziyao
 Creat Time : 15-08-19
 Description: storage manager.
 Copyright  : Copyright (c) 2012 Ziyao Yang. All rights reserved.
 *********************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    SINGLE_TYPE,
    MUTI_TYPE
} ARRAY_TYPE;

@interface StorageMgr : NSObject

/*!
 @method    singletonFWKextMgr:
 @abstract  get the instance;
 @result    instance;
 */
+ (StorageMgr*)singletonStorageMgr;

/*!
 @method    releaseInstance:
 @abstract  release the instance;
 @result    void;
 */
+ (void)releaseInstance;

/*!
 @method    addKeyAndValues:
 @abstract  add the key and Values;
 @result    void;
 */
- (void)addKeyAndValues:(NSString*) key And:(NSMutableDictionary*) dictionary;

/*!
 @method    addKeyAndValue:
 @abstract  add the key and value;
 @result    void;
 */
- (void)addKey:(NSString *)key andValue:(id)value;

- (void)removeObjectForKey:(NSString *)key;

/*!
 @method    dictionaryForKey:
 @abstract  get dictionary by key;
 @result    NSDictionary;
 */
- (NSDictionary*)dictionaryForKey:(NSString*) key;

/*!
 @method    stringForKey:
 @abstract  get string by key;
 @result    string;
 */
- (id)objectForKey:(NSString*) key;

/*!
 @method    stringForKey:Set:
 @abstract  set string by key;
 @result    BOOL;
 */
- (BOOL)stringForKey:(NSString*) key Set: (id) value;

/*!
 @method    storageMgrClone
 @abstract  clone storageMgr data;
 @result    NSMutableDictionary;
 */
- (NSMutableDictionary*)storageMgrClone:(ARRAY_TYPE) type;

/*!
 @method    storageMgrDictionary
 @abstract  clone storageMgr data;
 @result    NSMutableDictionary;
 */
- (NSMutableDictionary*)storageMgrDictionary:(ARRAY_TYPE) type;

/*!
 @method    removeAllData
 @abstract  clear data;
 @result    void;
 */
- (void)removeAllData:(ARRAY_TYPE) type;

@end
