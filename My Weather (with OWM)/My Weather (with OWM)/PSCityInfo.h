//
//  PSCityInfo.h
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 17.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;
@class PSCell;

@interface PSCityInfo : NSObject 

- (void)loadDataForViewController:(ViewController *)viewController;
- (void)loadDataForCell:(PSCell *)cell;
- (NSString *)loadDataForSearchViewControllerWithCityName:(NSString *)cityName;
- (NSString *)translateCityNameOnEnglish:(NSString *)untranslatedCityName;

@end
