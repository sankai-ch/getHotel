//
//  Utilities.h
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Ziyao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

//根据key获取缓存userDefault
+ (id)getUserDefaults:(NSString *)key;
//根据key设置userDefault
+ (void)setUserDefaults:(NSString *)key content:(id)value;
//根据key删除缓存userDefault
+ (void)removeUserDefaults:(NSString *)key;
//获得venderID的UUID字符串
+ (NSString *)uniqueVendor;
//根据id获取控制器实例
+ (id)getStoryboardInstanceByIdentity:(NSString*)identity;
//弹出普通提示框
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title onView:(UIViewController *)vc onCompletion:(void (^)(void))completion;
//获得保护膜
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view;
//将浮点数转化为保留小数点后若干位数的字符串
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
//根据URL下载图片并缓存
+ (UIImage *)imageUrl:(NSString *)url;
//设置接口令牌权限
+ (NSDictionary *)makeHeaderForToken:(NSString *)token;
//补0
+ (NSString *)checkZero:(NSInteger)num;
//隐藏手机号中间四位
+ (NSString *)invisiblePhoneNo:(NSString *)rawPhone;
//强制下线
+ (void)forceLogoutCheck:(NSInteger)code fromViewController:(UIViewController *)vc;
//为空检查
+ (id)nullAndNilCheck:(id)target replaceBy:(id)replacement;

/**
 *  字符串转时间戳
 *
 *  @param timeStr 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳的字符串
 */
+ (NSTimeInterval)cTimestampFromString:(NSString *)timeStr format:(NSString *)format;

/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp withDateFormat:(NSString *)format;

@end
