//
//  PSForecastViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 11.12.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSForecastViewController.h"
#import "PSLittleCardViewController.h"

@interface PSForecastViewController ()

@end

@implementation PSForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secondCellActivityIndicator.hidesWhenStopped = YES;
    [self.secondCellActivityIndicator startAnimating];
    
    self.littleCardsArray = [NSMutableArray new];
    
    self.firstCellScrollView.delegate = self;
    self.firstCellScrollView.showsHorizontalScrollIndicator = NO;
    self.firstCellScrollView.directionalLockEnabled = YES;
    self.firstCellScrollView.alwaysBounceVertical = NO;
    
    for (NSInteger i = 0; i < 40; i++) {
        
        PSLittleCardViewController* lcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PSLittleCardViewController"];
        CGRect rect;
        
        if (i == 0) {
            rect = CGRectMake(0, 0, 80, 110);
        } else {
            rect = CGRectMake(80*i, 0, 80, 110);
        }
        
        lcvc.view.frame = rect;
        [self.firstCellScrollView addSubview:lcvc.view];
        [self.littleCardsArray addObject:lcvc];

    }
    
    PSLittleCardViewController *lastControllerInArray = [self.littleCardsArray lastObject];
    CGSize contentSize = CGSizeMake(lastControllerInArray.view.frame.origin.x + lastControllerInArray.view.frame.size.width, 100); //110
    [self.firstCellScrollView setContentSize:contentSize];

    self.daysLabelArray = [NSMutableArray arrayWithObjects:self.firstDayLabel, self.secondDayLabel, self.thirdDayLabel, self.fourthDayLabel, self.fifthDayLabel, nil];
    self.weatherImagesArray = [NSMutableArray arrayWithObjects:self.firstDayImageView, self.secondDayImageView, self.thirdDayImageView, self.fourthDayImageView, self.fifthDayImageVIew, nil];
    self.maxTempLabelArray = [NSMutableArray arrayWithObjects:self.firstDayMaxTempLabel, self.secondDayMaxTempLabel, self.thirdDayMaxTempLabel, self.fourthDayMaxTempLabel, self.fifthDayMaxTempLabel, nil];
    self.minTempLabelArray = [NSMutableArray arrayWithObjects:self.firstDayMinTempLabel, self.secondDayMinTempLabel, self.thirdDayMinTempLabel, self.fourthDayMinTempLabel, self.fifthDayMinTempLabel, nil];

    
    NSArray *cellsArray = [NSArray arrayWithObjects:self.firstCell, self.secondCell, self.thirdCell, nil];
    
    for (UITableViewCell *cell in cellsArray) {
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
        topBorder.backgroundColor = [UIColor whiteColor].CGColor;
        [cell.layer addSublayer:topBorder];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
