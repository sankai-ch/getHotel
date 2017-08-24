//
//  ErrorHandler.m
//  Jianshenhui
//
//  Created by ZIYAO YANG on 16/7/14.
//  Copyright © 2016年 ZIYAO YANG. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (NSString *)getProperErrorString:(NSInteger)code {
    switch (code) {
        case 8002:
            return @"操作失败";
            break;
        case 8003:
            return @"提交成功";
            break;
        case 8004:
            return @"提交失败";
            break;
        case 8005:
            return @"操作失败";
            break;
        case 8006:
            return @"操作失败";
            break;
        case 8007:
            return @"更新成功";
            break;
        case 8008:
            return @"更新失败";
            break;
        case 8009:
            return @"插入成功";
            break;
        case 8010:
            return @"插入失败";
            break;
        case 8011:
            return @"验证码错误";
            break;
        case 8012:
            return @"注册成功";
            break;
        case 8013:
            return @"注册失败";
            break;
        case 8014:
            return @"参数为空";
            break;
        case 8015:
            return @"注册码获取超出次数,请明天再获取";
            break;
        case 8016:
            return @"该号已注册";
            break;
        case 8017:
            return @"该号码不存在，请先注册";
            break;
        case 8018:
            return @"操作失败";
            break;
        case 8019:
            return @"操作失败";
            break;
        case 8020:
            return @"暂无数据";
            break;
        case 8021:
            return @"暂无订单";
            break;
        case 8022:
            return @"该会员卡不存在";
            break;
        case 8023:
            return @"暂无订单";
            break;
        case 8024:
            return @"会所不存在";
            break;
        case 8025:
            return @"暂无优惠券";
            break;
        case 8026:
            return @"此优惠券不存在";
            break;
        case 8027:
            return @"该会员不存在";
            break;
        case 8028:
            return @"该号码不存在";
            break;
        case 8029:
            return @"密码错误";
            break;
        case 8030:
            return @"该手机未获得验证码";
            break;
        case 8031:
            return @"对应特色数据不存在";
            break;
        case 8032:
            return @"金额校验失败";
            break;
        default:
            return @"操作失败";
            break;
    }
}

@end
