//
//  Constants.h
//  Zhong Rui
//
//  Created by Ziyao on 15/9/8.
//  Copyright (c) 2015年 Ziyao. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//字体
#define S_Font 27
#define A_Font 17
#define B_Font 15
#define C_Font 13
#define D_Font 11

//颜色函数
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
//主题色
#define LOGIN_THEMECOLOR [UIColor colorWithRed:99.0/255.0 green:163.0/255.0 blue: 210.0/255.0 alpha:1.0]
//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:243/255.0 green:243/255.0 blue: 243/255.0 alpha:1]
//头部框颜色
#define HEAD_THEMECOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue: 255/255.0 alpha:1.0]

//通话结果按钮颜色
#define SELECTED_BTN_BG [UIColor colorWithRed:63/255.0 green:158/255.0 blue: 209/255.0 alpha:1.0]
#define UNSELECTE_TITLE_COLOR [UIColor colorWithRed:78/255.0 green:134/255.0 blue: 192/255.0 alpha:1.0]
#define UNSELECTE_BTN_BG [UIColor colorWithRed:174/255.0 green:205/255.0 blue: 223/255.0 alpha:1.0]
#define UNSELECTE_BORDER_COLOR [UIColor colorWithRed:150/255.0 green:183/255.0 blue: 228/255.0 alpha:1.0]
//屏幕尺寸
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height

//iOS版本
#define Earlier_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 8.0)
#define Later_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8.0)

//清理内存
#define FRelease(x) {[x removeFromSuperview]; x = nil;}

//设置Server
#define kServer @"http://121.41.18.135:9096"
//#define kServer @"http://192.168.2.187:9096"
#define kQNServer @"http://oo81h9152.bkt.clouddn.com/"

#endif
