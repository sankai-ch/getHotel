/********************************************************************
 File name  : storageMgr.h
 Editor     : Ziyao
 Creat Time : 15-08-19
 Description: storage manager.
 Copyright  : Copyright (c) 2012 Ziyao Yang. All rights reserved.
 *********************************************************************/

#import "StorageMgr.h"

@interface StorageMgr() {
    NSMutableDictionary* mutableDictionary;
    NSMutableDictionary* multiMutableDictionary;
}
-(id)initWithDefault;

@end

@implementation StorageMgr

static StorageMgr * _singletonStorageMgr = nil;

/*!
 @method    singletonFWStorageMgr
 @abstract  get FWStorageMgr instance;
 @result    get instance;
 */
#ifndef __clang_analyzer__
+ (StorageMgr *)singletonStorageMgr
{
	@synchronized(self) {
		if (nil == _singletonStorageMgr) {
			_singletonStorageMgr = [[StorageMgr alloc] initWithDefault];
		}
	}
	return _singletonStorageMgr;
}
#endif

/*!
 @method    releaseInstance
 @abstract  release instance;
 @result    void;
 */
+ (void)releaseInstance
{
	@synchronized(self) {
        _singletonStorageMgr = nil;
	}
}

/*!
 @method    allocWithZone
 @abstract  alloc with zone.
 @result    FWStorage instance;
 */
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
        if (_singletonStorageMgr == nil) {
            _singletonStorageMgr = [super allocWithZone:zone];
            return _singletonStorageMgr;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

/*!
 @method    copyWithZone
 @abstract  copy with zone.
 @result    FWStorage instance;
 */
- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

/*!
 @method    initWithDefault
 @abstract  init with default.
 @result    FWStorage instance;
 */
- (id)initWithDefault
{
	self= [super init];
	
	if(nil != self) {
        mutableDictionary = [[NSMutableDictionary alloc]init];
        multiMutableDictionary = [[NSMutableDictionary alloc]init];
		return self;
	} else {
		return nil;
    }
}

/*!
 @method    dealloc
 @abstract  dealloc instance
 @result    void;
 */
- (void)dealloc 
{
    [mutableDictionary removeAllObjects];
    [multiMutableDictionary removeAllObjects];
    multiMutableDictionary = nil;
    mutableDictionary = nil;
}

/*!
 @method    addKeyAndValues
 @abstract  add key and values.
 @result    void;
 */
- (void)addKeyAndValues:(NSString*) key And:(NSMutableDictionary*) dictionary
{
    @synchronized(self) {
        [multiMutableDictionary addEntriesFromDictionary:[NSMutableDictionary
                                                     dictionaryWithObjectsAndKeys:
                                                     dictionary, key,
                                                     nil]];
    }
}

/*!
 @method    addKeyAndValue
 @abstract  add key and value.
 @result    void;
 */
- (void)addKey:(NSString *)key andValue:(id)value
{
    @synchronized(self) {
        if (key == nil || value == nil) {
            return;
        }
        [mutableDictionary addEntriesFromDictionary:[NSMutableDictionary
                                                     dictionaryWithObjectsAndKeys:
                                                     value, key,
                                                     nil]];
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    @synchronized(self) {
        [mutableDictionary removeObjectForKey:key];
    }
}

/*!
 @method    dictionaryForKey
 @abstract  get dictionary by key.
 @result    NSDictionary;
 */
- (NSDictionary*)dictionaryForKey:(NSString*) key
{
    NSDictionary* ret = nil;
    NSString* string = [self isContains:key];
    if (string) {
        @synchronized(self) {
            ret =  [multiMutableDictionary objectForKey:string];
        }
    }
    return ret;
    
}

/*!
 @method    stringForKey
 @abstract  get string by key.
 @result    NSString;
 */
- (id)objectForKey:(NSString*) key
{
    if (key == nil) {
        return nil;
    }
    id sRet = key;
    if (sRet) {
        @synchronized(self) {
            sRet = [mutableDictionary objectForKey:sRet];
        }
    }
    return sRet;
    
}

/*!
 @method    stringForKey:Set
 @abstract  set string by key.
 @result    BOOL;
 */
- (BOOL)stringForKey:(NSString*) key Set: (id) value
{
    
    BOOL bRet = NO;
    NSString* string = [self isContains:key];
    if (string) {
        @synchronized(self) {
            if (mutableDictionary) {
                [mutableDictionary removeObjectForKey:string];
                [mutableDictionary setObject:value forKey:string];
                bRet  = YES;
            }
        }
    }
    return bRet;
    
}

/*!
 @method    isContains:key
 @abstract  isContains.
 @result    id;
 */
- (id)isContains:(NSString*) key {
    id keyObj = nil;
    
    @synchronized(self) {
        for (NSString* tmp in [mutableDictionary allKeys]) {
            if ([tmp isEqualToString:key]) {
                keyObj = tmp;
                break;
            }
        }
    }
    return keyObj;
}

/*!
 @method    storageMgrClone
 @abstract  clone storageMgr data;
 @result    NSMutableDictionary;
 */
- (NSMutableDictionary*)storageMgrClone:(ARRAY_TYPE) type
{
    NSMutableDictionary* ret = nil;
    if (type == SINGLE_TYPE) {
        if (mutableDictionary) {
            ret = [mutableDictionary mutableCopy];
        }
    } else {
        if (multiMutableDictionary) {
            ret = [multiMutableDictionary mutableCopy];
        }
    }
    return ret;
}

/*!
 @method    storageMgrDictionary
 @abstract  clone storageMgr data;
 @result    NSMutableDictionary;
 */
- (NSMutableDictionary*)storageMgrDictionary:(ARRAY_TYPE) type
{
    NSMutableDictionary* ret = nil;
    if (type == SINGLE_TYPE) {
        if (mutableDictionary) {
            ret = mutableDictionary;
        }
    } else {
        if (multiMutableDictionary) {
            ret = multiMutableDictionary;
        }
    }
    return ret;
}

/*!
 @method    removeAllData
 @abstract  clear data;
 @result    void;
 */
- (void)removeAllData:(ARRAY_TYPE) type
{
    if (type == SINGLE_TYPE) {
        if (mutableDictionary) {
            [mutableDictionary removeAllObjects];
        }
    } else {
        if (multiMutableDictionary) {
            [multiMutableDictionary removeAllObjects];
        }
    }
}

@end
