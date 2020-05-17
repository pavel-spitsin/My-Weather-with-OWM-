//
//  TodayViewController.m
//  Widget
//
//  Created by Павел Спицин on 11.02.20.
//  Copyright © 2020 Павел Спицин. All rights reserved.
//

#import "TodayViewController.h"
#import "PSConstants.h"
#import <NotificationCenter/NotificationCenter.h>
#import <CoreLocation/CoreLocation.h>

@interface TodayViewController () <NCWidgetProviding, NSURLSessionDataDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    
    NSString *requestString = [[NSString alloc] init];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&lang=ru&units=metric&APPID=%@", latitude, longitude, appID];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        double myDouble = [[[jsonObject objectForKey:@"main"] objectForKey:@"temp"] doubleValue];
        int myInt = (int)floor(myDouble);
        
        //Запрос иконки погоды с сервера
        NSString *iconString = [[[jsonObject objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
        NSString *urlString = [NSString stringWithFormat:@"https://openweathermap.org/img/wn/%@@2x.png", iconString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        //Блок обновления UI-элементов
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cityNameLabel.text = [jsonObject objectForKey:@"name"];
            self.descriptionLabel.text = [[[jsonObject objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
            
            //Заглавная буква первого слова
            self.descriptionLabel.text = [self.descriptionLabel.text
                                          stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                          withString:[[self.descriptionLabel.text substringToIndex:1] capitalizedString]];
            
            self.temperatureLabel.text = [NSString stringWithFormat:@"%d\u00B0", myInt];
            self.weatherImageView.image = image;
            
            [self.activityIndicator stopAnimating];
        });
        
    }];
    
    [dataTask resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
