//
//  PSViewControllerWithTableViewController.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 21.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSViewControllerWithTableViewController : UIViewController 

@property (strong, nonatomic) NSMutableArray *citiesArray;
@property (assign, nonatomic) NSInteger pageIndex;

@end
