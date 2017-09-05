//
//  HotelTableViewCell.m
//  GetHotels
//
//  Created by ll on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "HotelTableViewCell.h"
#import <pop/POP.h>
@implementation HotelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initializatin iion code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //根据事件获得事件对应的触摸实例
    UITouch *touch = [[event allTouches] anyObject];
    //根据触摸实例获得触摸在特定坐标系中的位置
    CGPoint location = [touch locationInView:self];
    //NSLog(@"%f,%f", location.x, location.y);
    UIView *ripple = [[UIView alloc] initWithFrame:CGRectMake(location.x - 5, location.y - 5, 10, 10)];
    ripple.layer.cornerRadius = 5;
    //ripple.backgroundColor =
}

@end
