//
//  PSPageViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 12.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *citiesArray;

@end
