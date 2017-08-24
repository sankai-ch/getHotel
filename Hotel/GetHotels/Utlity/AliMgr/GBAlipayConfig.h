//
//  GBAlipayConfig.h
//  支付宝极简支付
//
//  Created by marks on 15/6/3.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#ifndef ________GBAlipayConfig_h
#define ________GBAlipayConfig_h

#import <AlipaySDK/AlipaySDK.h>     // 导入AlipaySDK
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类
/**
 *  合作身份者id，以2088开头的16位纯数字
 */
#define PartnerID @"2088221892738826"

/**
 *  收款支付宝账号
 */
#define SellerID  @"app@etongit.com"

/**
 *  安全校验码（MD5）密钥，以数字和字母组成的32位字符
 */
#define MD5_KEY @"engja0nxb5py3w8o27ettzfy7yrjcip6"

/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"JSHAlipay2016"

/**
 *  支付宝服务器主动通知商户交易是否成功 网站里指定的页面 http 路径。非必需
 */
#define kNotifyURL @""

/**
 *  商户私钥，自助生成
 */
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMEI5eiaOBVpDtQMVWKeW6hCIP2QucIOVGVbr8SiO6IeIQDkFIyAZm0dJbZnay9ttpXExEUb6jTIC9Qv2ql/0sw+1gp35HKKXqgS25TqReOfizikuzzaCwYYIXMTF32icFC0rOeiiBlwkop57+YPW+IfZxHIdVFjGYX0fIhLlOnzAgMBAAECgYAfj2/ffs9qmLmm67lOHWwI737rVi040BT2WW48bPXpBJoKxj+h1SBp+JkA4JnCsGJozDn2vqClLovYjlZm3hI9r9osRJ5B79IvGpLSYyZQti2FoA9zHeX/b1a6DJFK0mJVlQV7Db/KH267bmgjlH6jodJ9rdrSgzQyQk9SC5jz2QJBAODzBmeIov4Vf+0YUnHZGq6QHzaHCc9N5+E7/d72WaVsAXmBONT8jf/XJc5MmESRLZ43mF06qTioiKBh3/WCql0CQQDbrh3fOYNInxji8Ha46nVzqcCuwfHhf7VSWBTFADVdiSX8STwwUTpe0RD5cI7hy1jeaHfPUtOZsDIwWSZd+sCPAkAy0fTCczYPnR/XmsUVf2ztvxWuJffrY7hdREZoltNN8garQqxqQdx6zkp2PwuvgfUCZ6D+fwA4Eqs7QKFuP+TpAkEAoJS8XUpLPzCdHnasMiugw3WY1aYLy8xwnMqqE/89AyyXyb029BLMWjb084Fl0IO2aI1w1uoypyt25ISmWRhM3QJAOyxRDnUceaXoxQPPXMU8/rroi7KnEUxjgfJ157GsDHVJImsNZlQ3RCOM03OL5MPeg16o9UcuMrMbKUx/RrcKPQ=="

/**
 *  支付宝公钥
 */
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif

