//
//  SSTableViewCell.h
//  hawudha
//
//  Created by admin1 on 2017/8/30.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (weak, nonatomic) IBOutlet UIView *view;

@end
