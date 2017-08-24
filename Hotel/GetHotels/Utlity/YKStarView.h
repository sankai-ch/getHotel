//
//  YKStarView.h
//  GetHotels
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKStarView : UIView
@property (nonatomic, assign) NSInteger maxStar;        // 最大值
@property (nonatomic, assign) NSInteger showStar;       // 显示值
@property (nonatomic, strong) UIColor *emptyColor;      // 空颜色
@property (nonatomic, strong) UIColor *fullColor;       // 满颜色


@end
