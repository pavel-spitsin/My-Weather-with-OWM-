//
//  PSLittleCardViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 18.12.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSLittleCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dayOfTheWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (weak, nonatomic) NSString *dayOfTheWeekLCVC;

@end
