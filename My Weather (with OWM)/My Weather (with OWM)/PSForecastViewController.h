//
//  PSForecastViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 11.12.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSLittleCardViewController;

@interface PSForecastViewController : UITableViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//First cell
@property (weak, nonatomic) IBOutlet UIScrollView *firstCellScrollView;
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) NSMutableArray *littleCardsArray;

//Second cell
@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthDayLabel;
@property (strong, nonatomic) NSMutableArray *daysLabelArray;

@property (weak, nonatomic) IBOutlet UIImageView *firstDayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondDayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthDayImageVIew;
@property (strong, nonatomic) NSMutableArray *weatherImagesArray;

@property (weak, nonatomic) IBOutlet UILabel *firstDayMaxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDayMaxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDayMaxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthDayMaxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthDayMaxTempLabel;
@property (strong, nonatomic) NSMutableArray *maxTempLabelArray;

@property (weak, nonatomic) IBOutlet UILabel *firstDayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthDayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthDayMinTempLabel;
@property (strong, nonatomic) NSMutableArray *minTempLabelArray;

@property (weak, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondCellActivityIndicator;


//Third cell
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *thirdCell;

@end
