//
//  PSSearchViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 27.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//


//Проверить presentation style



#import "PSSearchViewController.h"
#import "PSCityInfo.h"

@interface PSSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *cityCheckLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFoundCityButton;

- (IBAction)addCity:(UIButton *)sender;

@end

@implementation PSSearchViewController

#pragma mark - View controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addFoundCityButton setEnabled:NO];
    
    [self.searchBar becomeFirstResponder];
    
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator withObject:nil];
        
    self.cityCheckLabel.text = [self searchDataForCity:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    if ([self.cityCheckLabel.text isEqualToString:@"City not found"] != YES) {
        [self.addFoundCityButton setEnabled:YES];
    } else {
        [self.addFoundCityButton setEnabled:NO];
    }
    
    [self.activityIndicator stopAnimating];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.cityCheckLabel.text = nil;
    [self.addFoundCityButton setEnabled:NO];
}

#pragma mark - Actions

- (NSString *)searchDataForCity:(NSString *)cityName {
    PSCityInfo *cityInfo = [[PSCityInfo alloc] init];
    NSString *findedCity = [cityInfo loadDataForSearchViewControllerWithCityName:cityName];
    
    return findedCity;
}

- (IBAction)addCity:(UIButton *)sender {
    PSCityInfo *cityInfo = [[PSCityInfo alloc] init];
    [self.citiesArray addObject:[cityInfo translateCityNameOnEnglish:self.searchBar.text]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
