//
//  PSCityInfo.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 17.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSCityInfo.h"
#import "ViewController.h"
#import "PSCell.h"
#import "PSLittleCardViewController.h"
#import "PSConstants.h"

#import <CoreLocation/CoreLocation.h>

@interface PSCityInfo () <NSURLSessionDataDelegate, CLLocationManagerDelegate>

@end

@implementation PSCityInfo

- (void)loadDataForViewController:(ViewController *)viewController {
    [self getCurrentWeatherForViewController:viewController];
    [self loadFiveDayForecastForViewController:viewController];
}

- (void)loadDataForCell:(PSCell *)cell {
    [self getCurrentWeatherForCell:cell];
}


#pragma mark - Get data for View Controller

- (void)getCurrentWeatherForViewController:(ViewController *)viewController {
    
    NSString *requestString = [[NSString alloc] init];
    __block NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    
    //Определение строки запроса на сервер (по названию города или по геолокации)
    if (viewController.pageIndex == 0) {
        //По геолокации
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&lang=ru&units=metric&APPID=%@", latitude, longitude, appID];
        
    } else {
        //По названию города
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?q=%@&lang=ru&units=metric&APPID=%@",
                                   [viewController.cityName stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                   appID];
    }

    //Запрос данных погоды с сервера
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //Определение TimeZone для viewController
        NSInteger timeShift = [[jsonObject objectForKey:@"timezone"] integerValue]; //Смещение от UTC в секундах
    
        if (viewController.pageIndex == 0) {
            timeZone = [NSTimeZone systemTimeZone]; //TimeZone по геолокации
        } else {
            timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timeShift]; //TimeZone со смещением
        }
    
        //Создание NSDateFormatter времени
        NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
        [timeDateFormatter setTimeZone:timeZone];
        [timeDateFormatter setDateFormat:@"HH:mm"];
        
        //Вычисление Int для temperatureLabel
        double myDouble = [[[jsonObject objectForKey:@"main"] objectForKey:@"temp"] doubleValue];
        int myInt = (int)floor(myDouble);
    
        //Вычисление Int для pressureLabel
        float pressureFloat = [[[jsonObject objectForKey:@"main"] objectForKey:@"pressure"] floatValue];
        float pressureConverted = pressureFloat/1.333f;
        int pressureInt = (int)pressureConverted;
    
        //Вычисление double для tempMaxLabel
        double tempMaxDouble = [[[jsonObject objectForKey:@"main"] objectForKey:@"temp_max"] doubleValue];
    
        //Вычисление double для tempMinLabel
        double tempMinDouble = [[[jsonObject objectForKey:@"main"] objectForKey:@"temp_min"] doubleValue];
    
        //Вычисление даты (времени) для sunriseLabel и sunsetLabel
        NSInteger integerSunrise = [[[jsonObject objectForKey:@"sys"] objectForKey:@"sunrise"] integerValue];
        NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970:integerSunrise];
        NSString *sunriseTimeString = [timeDateFormatter stringFromDate:sunriseDate]; //время восхода
        
        NSInteger integerSunset = [[[jsonObject objectForKey:@"sys"] objectForKey:@"sunset"] integerValue];
        NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970:integerSunset];
        NSString *sunsetTimeString = [timeDateFormatter stringFromDate:sunsetDate]; //время заката
    
        //Вычисление направления ветра для windDirectionLabel
        NSInteger windDirectionInt = [[[jsonObject objectForKey:@"wind"] objectForKey:@"deg"] integerValue];
        NSString *windDirectionString = [[NSString alloc] init];
    
        if (windDirectionInt == 0) {
            windDirectionString = [NSString stringWithFormat:@"с"];
        } else if (0 < windDirectionInt && windDirectionInt < 45) {
            windDirectionString = [NSString stringWithFormat:@"ссв"];
        } else if (windDirectionInt == 45) {
            windDirectionString = [NSString stringWithFormat:@"св"];
        } else if (45 < windDirectionInt && windDirectionInt < 90) {
            windDirectionString = [NSString stringWithFormat:@"ввс"];
        } else if (windDirectionInt == 90) {
            windDirectionString = [NSString stringWithFormat:@"в"];
        } else if (90 < windDirectionInt && windDirectionInt < 135) {
            windDirectionString = [NSString stringWithFormat:@"вюв"];
        } else if (windDirectionInt == 135) {
            windDirectionString = [NSString stringWithFormat:@"юв"];
        } else if (135 < windDirectionInt && windDirectionInt < 180) {
            windDirectionString = [NSString stringWithFormat:@"ююв"];
        } else if (windDirectionInt == 180) {
            windDirectionString = [NSString stringWithFormat:@"ю"];
        } else if (180 < windDirectionInt && windDirectionInt < 225) {
            windDirectionString = [NSString stringWithFormat:@"ююз"];
        } else if (windDirectionInt == 225) {
            windDirectionString = [NSString stringWithFormat:@"юз"];
        } else if (225 < windDirectionInt && windDirectionInt < 270) {
            windDirectionString = [NSString stringWithFormat:@"зюз"];
        } else if (windDirectionInt == 270) {
            windDirectionString = [NSString stringWithFormat:@"з"];
        } else if (270 < windDirectionInt && windDirectionInt < 315) {
            windDirectionString = [NSString stringWithFormat:@"зсз"];
        } else if (315 < windDirectionInt && windDirectionInt < 360) {
            windDirectionString = [NSString stringWithFormat:@"ссз"];
        }
    
        //Запрос иконки погоды с сервера
        NSString *iconString = [[[jsonObject objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
        NSString *urlString = [NSString stringWithFormat:@"https://openweathermap.org/img/wn/%@@2x.png", iconString];
        NSURL *imageURL = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
    
        //Блок обновления UI-элементов
        dispatch_async(dispatch_get_main_queue(), ^{
            viewController.cityLabel.text = [jsonObject objectForKey:@"name"];
            viewController.descriptionLabel.text = [[[jsonObject objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
            
            //Заглавная буква первого слова
            viewController.descriptionLabel.text = [viewController.descriptionLabel.text
                                          stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                          withString:[[viewController.descriptionLabel.text substringToIndex:1] capitalizedString]];
            
            viewController.temperatureLabel.text = [NSString stringWithFormat:@"%d\u00B0", myInt]; //u00B0C - с цельсиями
            viewController.forecastVC.cloudsLabel.text = [NSString stringWithFormat:@"%@ %%", [[jsonObject objectForKey:@"clouds"] objectForKey:@"all"]];
            viewController.forecastVC.humidityLabel.text = [NSString stringWithFormat:@"%@ %%", [[jsonObject objectForKey:@"main"] objectForKey:@"humidity"]];
            viewController.forecastVC.pressureLabel.text = [NSString stringWithFormat:@"%d мм рт. ст.", pressureInt];
            viewController.forecastVC.tempMaxLabel.text = [NSString stringWithFormat:@"%.0f\u00B0", tempMaxDouble];
            viewController.forecastVC.tempMinLabel.text = [NSString stringWithFormat:@"%.0f\u00B0", tempMinDouble];
            viewController.forecastVC.sunriseLabel.text = [NSString stringWithFormat:@"%@", sunriseTimeString];
            viewController.forecastVC.sunsetLabel.text = [NSString stringWithFormat:@"%@", sunsetTimeString];
            viewController.forecastVC.windDirectionLabel.text = [NSString stringWithFormat:@"%@", windDirectionString];
            viewController.forecastVC.windSpeedLabel.text = [NSString stringWithFormat:@"%@ м/с", [[jsonObject objectForKey:@"wind"] objectForKey:@"speed"]];
            viewController.forecastVC.visibilityLabel.text = [NSString stringWithFormat:@"%@ м", [jsonObject objectForKey:@"visibility"]];

            viewController.imageView.image = image;
            
            [viewController.mainBoardActivityIndicator stopAnimating];
        });
        
    }];
    
    [dataTask resume];
        
}

#pragma mark - Get forecast for view controller

- (void)loadFiveDayForecastForViewController:(ViewController *)viewController {
    
    NSString *requestString = [[NSString alloc] init];
    __block NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    
    //Определение строки запроса на сервер (по названию города или по геолокации)
    if (viewController.pageIndex == 0) {
        //По геолокации
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];

        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/forecast?lat=%@&lon=%@&lang=ru&units=metric&APPID=%@", latitude, longitude, appID];
        
    } else {
        //По названию города
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/forecast?q=%@&lang=ru&units=metric&APPID=%@",
                                   [viewController.cityName stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                   appID];
    }

    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //Определение TimeZone для текущего viewController
        NSInteger timeShift = [[[jsonObject objectForKey:@"city"] objectForKey:@"timezone"] integerValue]; //Смещение от UTC в секундах
        
        if (viewController.pageIndex == 0) {
            timeZone = [NSTimeZone systemTimeZone];
        } else {
            timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timeShift]; //NSTimeZone по геолокации
        }
        
        //Создание NSDateFormatter времени
        NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
        [timeDateFormatter setTimeZone:timeZone];
        [timeDateFormatter setDateFormat:@"HH:mm"];
        
        //Создание NSDateFormatter дня недели
        NSDateFormatter *dayOfTheWeekDateFormatter = [[NSDateFormatter alloc] init];
        [dayOfTheWeekDateFormatter setTimeZone:timeZone];
        [dayOfTheWeekDateFormatter setDateFormat:@"EEEE"];
        
        //Создание и заполнение карточек погоды (интервал - 3 часа)
        for (PSLittleCardViewController *littleCard in viewController.forecastVC.littleCardsArray) {
            
            //Определение содержимого для лейбла timeLabel
            long timeLong = [[[[jsonObject objectForKey:@"list"]
                               objectAtIndex:[viewController.forecastVC.littleCardsArray indexOfObject:littleCard]]
                              objectForKey:@"dt"]
                             longValue];
            
            NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeLong];
            NSString *timeString = [timeDateFormatter stringFromDate:timeDate];
            NSString *dayOfTheWeekString = [[NSString alloc] init];
            
            if ([timeString isEqualToString:@"00:00"] || [timeString isEqualToString:@"01:00"] || [timeString isEqualToString:@"02:00"]) {
                dayOfTheWeekString = [dayOfTheWeekDateFormatter stringFromDate:timeDate];
            }
            
            //Запрос иконки
            NSString *urlString = [NSString stringWithFormat:@"https://openweathermap.org/img/wn/%@@2x.png",
                                   [[[[[jsonObject objectForKey:@"list"]
                                       objectAtIndex:[viewController.forecastVC.littleCardsArray indexOfObject:littleCard]]
                                      objectForKey:@"weather"] objectAtIndex:0]
                                    objectForKey:@"icon"]];
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage* image = [[UIImage alloc] initWithData:data];

            //Блок обновления UI-элементов карточек (первая ячейка таблицы)
            dispatch_async(dispatch_get_main_queue(), ^{
                 
                littleCard.timeLabel.text = [NSString stringWithFormat:@"%@", timeString];
                littleCard.dayOfTheWeekLabel.text = [dayOfTheWeekString capitalizedString];
                
                if (littleCard == [viewController.forecastVC.littleCardsArray objectAtIndex:0] && [timeString isEqualToString:@"00:00"] == NO) {
                    littleCard.dayOfTheWeekLabel.text = @"Сегодня";
                }

                if ([timeString isEqualToString:@"00:00"] || [timeString isEqualToString:@"01:00"] || [timeString isEqualToString:@"02:00"]) {
                    CALayer *leftBorder = [CALayer layer];
                    leftBorder.frame = CGRectMake(0.0f, 0.0f, 1.0f, littleCard.view.frame.size.height);
                    leftBorder.backgroundColor = [UIColor whiteColor].CGColor;
                    [littleCard.view.layer addSublayer:leftBorder];
                }

                double feelsLikeTempDouble = [[[[[jsonObject objectForKey:@"list"]
                                                 objectAtIndex:[viewController.forecastVC.littleCardsArray indexOfObject:littleCard]]
                                                objectForKey:@"main"]
                                               objectForKey:@"temp"]
                                              doubleValue];
                
                littleCard.temperatureLabel.text = [NSString stringWithFormat:@"%.f\u00B0", feelsLikeTempDouble];
                littleCard.weatherImageView.image = image;
             
                [littleCard.activityIndicator stopAnimating];
                
                CGPoint copyPoint = CGPointMake(littleCard.weatherImageView.frame.origin.x - 16, littleCard.weatherImageView.frame.origin.y - 16);
                
                [UIView animateWithDuration:0.5
                                      delay:0.3
                     usingSpringWithDamping:0.4
                      initialSpringVelocity:0.5
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [littleCard.view layoutIfNeeded];
                                     CGRect frame = CGRectMake(copyPoint.x, copyPoint.y, 30, 30);
                                     littleCard.weatherImageView.frame = frame;
                                 }
                                 completion:NULL];
            });

        }
        
        //Вычисление средней max и min температуры по дням недели
        // Распределение массивов по дням недели
        NSMutableArray *daysArray = [[NSMutableArray alloc] init];

        NSDate *currentDate = [NSDate date];
        
        for (NSUInteger i = 0; i < [[jsonObject objectForKey:@"list"] count]; i++) {
         
            long dayLong = [[[[jsonObject objectForKey:@"list"] objectAtIndex:i] objectForKey:@"dt"] longValue];
            NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:dayLong];
            NSString *timeString = [timeDateFormatter stringFromDate:timeDate];
            
            //Проверка по дням недели (исключение текущего дня)
            NSString *currentDateString = [dayOfTheWeekDateFormatter stringFromDate:currentDate];
            NSString *dayDayString = [dayOfTheWeekDateFormatter stringFromDate:timeDate];
            
            if ([dayDayString isEqualToString:currentDateString] == NO) {
                if ([timeString isEqualToString:@"00:00"] || [timeString isEqualToString:@"01:00"] || [timeString isEqualToString:@"02:00"]) {
                    NSMutableArray *nextDayArray = [[NSMutableArray alloc] init];
                    [nextDayArray addObject:[[jsonObject objectForKey:@"list"] objectAtIndex:i]];
                    [daysArray addObject:nextDayArray];
                } else {
                    [[daysArray lastObject] addObject:[[jsonObject objectForKey:@"list"] objectAtIndex:i]];
                }
            }
            
        }
        
        //Создание массивов мин+макс температур, распределение по массивам дней
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        for (NSArray *array in daysArray) {
            
            NSMutableArray *tempForDayArray = [[NSMutableArray alloc] init];
            [tempArray addObject:tempForDayArray];
    
            for (NSDictionary *dictionary in array) {
                double minTempDouble = [[[dictionary objectForKey:@"main"] objectForKey:@"temp_min"] doubleValue];
                double maxTempDouble = [[[dictionary objectForKey:@"main"] objectForKey:@"temp_max"] doubleValue];
                NSNumber *minTempNumber = [NSNumber numberWithDouble:minTempDouble];
                NSNumber *maxTempNumber = [NSNumber numberWithDouble:maxTempDouble];
                [tempForDayArray addObject:minTempNumber];
                [tempForDayArray addObject:maxTempNumber];
            }
            
        }
        
        //Сортировка и поиск наибольшего и наименьшего
        NSMutableArray *minMaxTemperatureForDayArray = [[NSMutableArray alloc] init];
        
        for (NSArray *array in tempArray) {
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:nil];
            NSArray* sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
            [minMaxTemperatureForDayArray addObject:sortedArray];
        }

        //Создание массива иконок погоды и поиск наиболее подходящей
        NSMutableArray *iconsForFiveDaysArray = [[NSMutableArray alloc] init];
            
            for (NSArray *array in daysArray) {
                
                NSMutableArray *iconsForDayArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dictionary in array) {
                    NSString *iconString = [[[dictionary objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
                    [iconsForDayArray addObject:iconString];
                }
                
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:nil];
                NSArray* sortedIconsArray = [iconsForDayArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                NSMutableArray *arrayOfEqualIcons = [[NSMutableArray alloc] init];
                NSMutableArray *eqArray = [[NSMutableArray alloc] init];
                [arrayOfEqualIcons addObject:eqArray];

                for (NSString *string in sortedIconsArray) {
                    if (string == [sortedIconsArray objectAtIndex:0]) {
                        [eqArray addObject:string];
                        continue;
                    } else if ([string isEqualToString:[[arrayOfEqualIcons lastObject] objectAtIndex:0]]) {
                        [[arrayOfEqualIcons lastObject] addObject:string];
                    } else {
                        NSMutableArray *unequalIcons = [[NSMutableArray alloc] init];
                        [arrayOfEqualIcons addObject:unequalIcons];
                        [unequalIcons addObject:string];
                    }
                }
                
                [iconsForFiveDaysArray addObject:arrayOfEqualIcons];
                
            }
        
        //Сортировка входящих массивов по размеру (по увеличению)
        NSMutableArray *ascendingIconsArray = [[NSMutableArray alloc] init];

        for (NSArray *array in iconsForFiveDaysArray) {
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"@count" ascending:YES];
            NSArray* sortedIconsArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
            [ascendingIconsArray addObject:sortedIconsArray];
        }
        
        //Заполнение UI-элементов прогноза на 5 дней (вторая ячейка таблицы)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSUInteger i = 0; i < 5; i++) {
                //Заполнение лейблов дней недели
                long dayOfWeek = [[[[daysArray objectAtIndex:i] objectAtIndex:0] objectForKey:@"dt"] longValue];
                NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:dayOfWeek];
                NSString *dayOfWeekString = [dayOfTheWeekDateFormatter stringFromDate:timeDate];
                
                UILabel *dayLabel = [viewController.forecastVC.daysLabelArray objectAtIndex:i];
                dayLabel.text = [dayOfWeekString capitalizedString];
                
                //Заполнение лейблов min max temp
                UILabel *minTempLabel = [viewController.forecastVC.minTempLabelArray objectAtIndex:i];
                minTempLabel.text = [NSString stringWithFormat:@"%.f\u00B0", [[[minMaxTemperatureForDayArray objectAtIndex:i] firstObject] doubleValue]];
                
                UILabel *maxTempLabel = [viewController.forecastVC.maxTempLabelArray objectAtIndex:i];
                maxTempLabel.text = [NSString stringWithFormat:@"%.f\u00B0", [[[minMaxTemperatureForDayArray objectAtIndex:i] lastObject] doubleValue]];
            }
            
            //Установка наиболее вероятных иконок погоды по дням недели
            for (NSArray *array in ascendingIconsArray) {
                
                NSString *urlString = [NSString stringWithFormat:@"https://openweathermap.org/img/wn/%@@2x.png", [[array lastObject] objectAtIndex:0]];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage* image = [[UIImage alloc] initWithData:data];
                
                NSUInteger i = [ascendingIconsArray indexOfObject:array];
                
                UIImageView *imgView = [viewController.forecastVC.weatherImagesArray objectAtIndex:i];
                [imgView setImage:image];
                
            }
            
            //Анимирование иконок погоды второй ячейи таблицы
            for (UIImageView *imgView in viewController.forecastVC.weatherImagesArray) {
                
                //Костыль - уменьшение иконок до 2х2 (в сториборде 30х30) для последующего анимированного увеличения
                [UIView animateWithDuration:0.01
                                 animations:^{
                                     [viewController.view layoutIfNeeded];
                                     imgView.frame = CGRectMake(imgView.frame.origin.x + 16, imgView.frame.origin.y + 16, 2, 2);
                                 }];

                //Анимирование иконок
                CGPoint copyPoint = CGPointMake(imgView.frame.origin.x - 16, imgView.frame.origin.y - 16);
                
                [UIView animateWithDuration:0.5
                                      delay:(0.15 + 0.05*[viewController.forecastVC.weatherImagesArray indexOfObject:imgView])
                     usingSpringWithDamping:0.4
                      initialSpringVelocity:0.5
                                    options:UIViewAnimationOptionLayoutSubviews
                                 animations:^{
                                     [viewController.view layoutIfNeeded];
                                     imgView.frame = CGRectMake(copyPoint.x, copyPoint.y, 30, 30);
                                 }
                                 completion:NULL];
            }
            
            [viewController.forecastVC.secondCellActivityIndicator stopAnimating];
            
        });
 
    }];
    
    [dataTask resume];
    
}


#pragma mark - Get data for cell

- (void)getCurrentWeatherForCell:(PSCell *)cell {
    
    NSString *requestString = [[NSString alloc] init];
    
    //Определение строки запроса на сервер (по названию города или по геолокации)
    if (cell.index == 0) {
        //По геолокации
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&lang=ru&units=metric&APPID=%@", latitude, longitude, appID];
        
    } else {
        //По названию города
        requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?q=%@&lang=ru&units=metric&APPID=%@",
                                   [cell.cityName stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                   appID];
        
    }
    
    //Запрос данных погоды с сервера
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
            
            if (cell.index != 0 || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                cell.cityNameLabel.text = [jsonObject objectForKey:@"name"];
                cell.descriptionLabel.text = [[[[jsonObject objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"] capitalizedString];
                cell.temperatureLabel.text = [NSString stringWithFormat:@"%d\u00B0", myInt];
                cell.weatherImageView.image = image;
                
                [cell.activityIndicator stopAnimating];
            }

        });
        
    }];
    
    [dataTask resume];
    
}


#pragma mark - Get data for search view controller

- (NSString *)loadDataForSearchViewControllerWithCityName:(NSString *)cityName {

    NSString *translatedCityNameOnEnglish = [self translateCityNameOnEnglish:cityName];
    
    NSString *findedCity = [[NSString alloc] init];
    
    //Запрос данных погоды с сервера
    NSString *requestString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?q=%@&lang=ru&units=metric&APPID=%@",
                               [translatedCityNameOnEnglish stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                               appID];
    NSURL *url = [NSURL URLWithString:requestString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data) {
        //Если данные прилетели - передаем строку в findedCity
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        findedCity = [NSString stringWithFormat:@"%@, %@", [jsonObject objectForKey:@"name"], [[jsonObject objectForKey:@"sys"] objectForKey:@"country"]];
    } else {
        //Если данные не прилетели - передаем строку "City not found" в findedCity
        findedCity = [NSString stringWithFormat:@"City not found"];
    }

    return findedCity; //Возвращаем наименование города или "City not found"
    
}

- (NSString *)translateCityNameOnEnglish:(NSString *)untranslatedCityName {
    
    NSString *yandexRequestString = [NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=en",
                                     yandexID,
                                     [untranslatedCityName stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    yandexRequestString = [yandexRequestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *yandexURL = [NSURL URLWithString:yandexRequestString];
    NSData *yandexData = [NSData dataWithContentsOfURL:yandexURL];
    NSDictionary *yandexJSONObject = [NSJSONSerialization JSONObjectWithData:yandexData options:0 error:nil];
    NSString *translatedCity = [NSString stringWithFormat:@"%@", [[yandexJSONObject objectForKey:@"text"] objectAtIndex:0]];
    
    return translatedCity;
}


@end
