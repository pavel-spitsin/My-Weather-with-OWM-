//
//  ViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 06.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSForecastViewController.h"

@interface ViewController : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *cityName;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainBoardActivityIndicator;



@property (strong, nonatomic) PSForecastViewController *forecastVC;

@property (assign, nonatomic) BOOL authorizationStatus;

@end

