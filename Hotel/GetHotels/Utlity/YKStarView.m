//
//  YKStarView.m
//  GetHotels
//
//  Created by admin1 on 2017/8/24.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "YKStarView.h"
#define YKStarFont [UIFont systemFontOfSize:14]  // 星星size宏定义
@implementation YKStarView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        //未点亮时的颜色是 灰色的
        self.emptyColor = [UIColor grayColor];
        
        //点亮时的颜色是 亮黄色的
        self.fullColor = [UIColor orangeColor];
        
        //默认的长度设置为100
        self.maxStar = 100;
    }
    
    return self;
}


//重绘视图
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    
    rect = self.bounds;
    CGSize starSize = [stars sizeWithFont:YKStarFont];
    rect.size=starSize;
    [_emptyColor set];
    [stars drawInRect:rect withFont:YKStarFont];
    
    CGRect clip = rect;
    clip.size.width = clip.size.width * _showStar / _maxStar;
    CGContextClipToRect(context,clip);
    [_fullColor set];
    [stars drawInRect:rect withFont:YKStarFont];
    
}
@end
