//
//  PSSearchViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 27.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSearchViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *citiesArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (NSString *)searchDataForCity:(NSString *)cityName;

@end
