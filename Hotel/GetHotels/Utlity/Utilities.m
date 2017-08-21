//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uniqueVendor
{
    NSString *uniqueIdentifier = [Utilities getUserDefaults:@"kKeyVendor"];
    if (!uniqueIdentifier || uniqueIdentifier.length == 0) {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        uniqueIdentifier = [uuid UUIDString];
        [Utilities setUserDefaults:@"kKeyVendor" content:uniqueIdentifier];
    }
    return uniqueIdentifier;
}

+ (id)getStoryboardInstanceByIdentity:(NSString*)identity
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}

+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title onView:(UIViewController *)vc onCompletion:(void (^)(void))completion
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion();
    }];
    [alertView addAction:cancelAction];
    [vc presentViewController:alertView animated:YES completion:nil];
}

+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIImage *)imageUrl:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    static dispatch_queue_t backgroundQueue;
    if (backgroundQueue == nil) {
        backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
    }
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    __block NSString *filePath = nil;
    filePath = [documentDirectory stringByAppendingPathComponent:[url lastPathComponent]];
    UIImage *imageInFile = [UIImage imageWithContentsOfFile:filePath];
    if (imageInFile) {
        return imageInFile;
    }
    
    __block NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (!data) {
        NSLog(@"Error retrieving %@", url);
        return nil;
    }
    UIImage *imageDownloaded = [[UIImage alloc] initWithData:data];
    dispatch_async(backgroundQueue, ^(void) {
        [data writeToFile:filePath atomically:YES];
        //NSLog(@"Wrote to: %@", filePath);
    });
    return imageDownloaded;
}

+ (NSDictionary *)makeHeaderForToken:(NSString *)token {
    return @{@"key" : @"x-auth-token", @"value" : [Utilities nullAndNilCheck:token replaceBy:@""]};
}

/**
 *  字符串转时间戳
 *
 *  @param timeStr 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd,即2015-07-15
 *
 *  @return 返回时间戳的字符串
 */
+(NSTimeInterval)cTimestampFromString:(NSString *)timeStr format:(NSString *)format{
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat = format;
    NSDate *date = [matter dateFromString:timeStr];
    NSTimeInterval timeStamp = [date timeIntervalSince1970]*1000;
    
    return timeStamp;
}

/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp withDateFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeStamp / 1000)];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat = format;
    
    NSString *timeStr = [matter stringFromDate:date];
    return timeStr;
}

+ (NSString *)checkZero:(NSInteger)num {
    if (num < 10) {
        return [NSString stringWithFormat:@"0%ld", (long)num];
    } else {
        return [NSString stringWithFormat:@"%ld", (long)num];
    }
}

+ (NSString *)invisiblePhoneNo:(NSString *)rawPhone {
    if (rawPhone.length >= 11) {
        NSString *header = [rawPhone substringToIndex:(rawPhone.length - 8)];
        NSString *footer = [rawPhone substringFromIndex:(rawPhone.length - 4)];
        return [NSString stringWithFormat:@"%@****%@", header, footer];
    } else if (rawPhone.length >= 7) {
        NSString *header = [rawPhone substringToIndex:(rawPhone.length - 6)];
        NSString *footer = [rawPhone substringFromIndex:(rawPhone.length - 3)];
        return [NSString stringWithFormat:@"%@***%@", header, footer];
    } else {
        return rawPhone;
    }
}

+ (void)forceLogoutCheck:(NSInteger)code fromViewController:(UIViewController *)vc {
    if (code == 403) {
        [Utilities popUpAlertViewWithMsg:@"您的账号已在其他地方登录" andTitle:nil onView:vc.navigationController.tabBarController onCompletion:^ {
            NSNotification *note = [NSNotification notificationWithName:@"DestroyTimer" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"token"];
            
            [vc dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:nil onView:vc.navigationController.tabBarController onCompletion:^ {
        }];
    }
}

+ (id)nullAndNilCheck:(id)target replaceBy:(id)replacement {
    if ([target isKindOfClass:[NSNull class]]) {
        return replacement;
    } else {
        if (target == nil) {
            return replacement;
        } else {
            if ([target isKindOfClass:[NSString class]]) {
                if ([target isEqualToString:@""]) {
                    return replacement;
                } else {
                    return target;
                }
            } else {
                return target;
            }
        }
    }
}

@end
