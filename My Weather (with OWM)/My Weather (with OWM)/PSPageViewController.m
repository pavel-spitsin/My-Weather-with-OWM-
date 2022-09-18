//
//  PSPageViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 12.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSPageViewController.h"
#import "ViewController.h"
#import "PSCityInfo.h"
#import "PSViewControllerWithTableViewController.h"
#import "UIColor+PSCustomColors.h"

#import <CoreLocation/CoreLocation.h>


#define kCity @"kCity"

@interface PSPageViewController () <UITabBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) PSCityInfo *cityInfo;

@property (strong, nonatomic) NSMutableArray *viewControllersArray;

@property (weak, nonatomic) UIPageControl *myPageControl;
@property (weak, nonatomic) UIToolbar *toolBar;

@property (weak, nonatomic) PSViewControllerWithTableViewController *tableVC;
@property (assign, nonatomic) NSInteger pageIndex;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PSPageViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    
    self.pageIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.delegate = self;
    self.dataSource = self;
    
    if (self.citiesArray == nil) {
        self.citiesArray = [NSMutableArray arrayWithObject:@"location"];
    }
    
    [self loadData];
    /*
    ViewController *initialVC = [self viewControllerAtIndex:0];
    self.viewControllersArray = [NSMutableArray arrayWithObject:initialVC];
    [self setViewControllers:self.viewControllersArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    */
    self.view.backgroundColor = [UIColor myColor];
    
    self.myPageControl = [UIPageControl appearance];
    self.myPageControl.backgroundColor = [UIColor clearColor];
    self.myPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.myPageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    CGRect toolBarRect = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:toolBarRect];
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
    self.toolBar.barTintColor = self.view.backgroundColor;
    self.toolBar.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *tabBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openCitiesTable)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexibleSpace, tabBarItem, nil];
    [self.toolBar setItems:itemsArray];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (UIView *sub in self.view.subviews) {
        NSString *str = [NSString new];
        str = NSStringFromClass([sub class]);
        if ([str isEqualToString:@"UIPageControl"]) {
            CGRect rec = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/3/2, self.toolBar.frame.origin.y, self.view.frame.size.width/3, self.toolBar.frame.size.height);
            sub.frame = rec;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {

    self.pageIndex = self.tableVC.pageIndex;
    
    ViewController *initialVC = [self viewControllerAtIndex:self.pageIndex];
    self.viewControllersArray = [NSMutableArray arrayWithObject:initialVC];
    [self setViewControllers:self.viewControllersArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.myPageControl.numberOfPages = [self.citiesArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerBeforeViewController: (UIViewController *)viewController{
    NSUInteger index = ((ViewController *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerAfterViewController: (UIViewController *)viewController{
    NSUInteger index = ((ViewController *) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.citiesArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.citiesArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageIndex;
}

// helper method
- (ViewController *)viewControllerAtIndex:(NSUInteger)index {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.pageIndex = index;
    vc.cityName = [self.citiesArray objectAtIndex:index];
    return vc;
}


#pragma mark - Actions

- (void)openCitiesTable {
    self.tableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PSViewControllerWithTableViewController"];
    self.tableVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.tableVC.citiesArray = self.citiesArray;
    [self presentViewController:self.tableVC animated:YES completion:nil];
}


#pragma mark - Data Actions

- (void)loadData {
    
    NSArray *cities = [[NSUserDefaults standardUserDefaults] objectForKey:kCity];
    
    for (NSData* data in cities) {
        [self.citiesArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    
}

- (void)saveData {
    
    NSMutableArray *archiveArray = [NSMutableArray array];
    
    for (NSString *city in self.citiesArray) {
        
        if ([city isEqualToString:@"location"] == NO) {
            NSData *dataObject = [NSKeyedArchiver archivedDataWithRootObject:city];
            [archiveArray addObject:dataObject];
        }
        
    }
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:archiveArray forKey:kCity];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        ViewController *initialVC = [self viewControllerAtIndex:0];
        self.viewControllersArray = [NSMutableArray arrayWithObject:initialVC];
        [self setViewControllers:self.viewControllersArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    
}


@end
