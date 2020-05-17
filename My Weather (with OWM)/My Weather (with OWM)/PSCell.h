//
//  PSCell.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 21.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *cityName;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
