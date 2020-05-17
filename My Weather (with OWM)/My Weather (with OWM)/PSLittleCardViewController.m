//
//  PSLittleCardViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 18.12.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSLittleCardViewController.h"

@interface PSLittleCardViewController ()

@end

@implementation PSLittleCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
