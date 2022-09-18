//
//  ViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 06.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

//НАДО ДОРАБОТАТЬ!!!!

#import "ViewController.h"
#import "PSCityInfo.h"
#import "UIColor+PSCustomColors.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation ViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mainBoardActivityIndicator.hidesWhenStopped = YES;
    [self.mainBoardActivityIndicator startAnimating];
    
    self.view.backgroundColor = [UIColor myColor];
    
    self.forecastVC = self.childViewControllers.firstObject;
    
    if (self.pageIndex != 0) {
        [self loadData];
    } else if (self.pageIndex == 0 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self loadData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {

    if (self.pageIndex == 0) {
        UIImage *arrowImage = [UIImage imageNamed:@"NavigationArrow.png"];
        self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        
        CGRect rect = CGRectMake(self.arrowContainerView.frame.size.width/2, self.arrowContainerView.frame.size.height/2, 0, 0);
        self.arrowImageView.frame = rect;
        self.arrowImageView.alpha = 0.0;
        
        [self.arrowContainerView addSubview:self.arrowImageView];
        
        [UIView animateWithDuration:1.3 //1.8
                              delay:0.0//0.5 //0.5
             usingSpringWithDamping:0.5 //0.3
              initialSpringVelocity:0.2 //0.5
                            options:UIViewAnimationOptionCurveEaseInOut //0
                         animations:^{
            self.arrowImageView.frame = self.arrowContainerView.bounds;
            self.arrowImageView.alpha = 1.0;
                             
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
                         completion:NULL];
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [self.arrowImageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    PSCityInfo *cityInfo = [[PSCityInfo alloc] init];
    [cityInfo loadDataForViewController:self];
}

@end
