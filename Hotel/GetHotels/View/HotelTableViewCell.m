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
    ripple.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.13];
    [self addSubview:ripple];
    POPBasicAnimation *rippleSizeAnimation = [POPBasicAnimation animation];
    rippleSizeAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
    rippleSizeAnimation.duration = 0.25;
    rippleSizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(120, 120)];
    [ripple pop_addAnimation:rippleSizeAnimation forKey:@"rippleSizeAnimation"];
    POPBasicAnimation *rippleCRAnimation = [POPBasicAnimation animation];
    rippleCRAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
    rippleCRAnimation.duration = 0.25;
    rippleCRAnimation.toValue = @60;
    [ripple.layer pop_addAnimation:rippleCRAnimation forKey:@"rippleCRAnimation"];
    rippleCRAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [ripple removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti" object:@(_row)];
    };
}

@end
