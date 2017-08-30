//
//  DetailViewController.h
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
@interface DetailViewController : UIViewController
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *price1;
=======
@property (nonatomic) NSInteger *hotelId;
@property (strong,nonatomic) NSString *timestartdate;
@property (strong,nonatomic) NSString *timeenddate;
@property (strong,nonatomic) NSString *hotelid;
>>>>>>> 5b492e971e52a6dfaf396bef4bf9a7b478a04bff
@end
