//
//  PSViewControllerWithTableViewController.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 21.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSViewControllerWithTableViewController.h"
#import "PSCell.h"
#import "PSCityInfo.h"
#import "PSSearchViewController.h"
#import "PSPageViewController.h"

@interface PSViewControllerWithTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

- (IBAction)openSearchViewController:(UIBarButtonItem *)sender;
- (IBAction)editAction:(UIBarButtonItem *)sender;

@end

@implementation PSViewControllerWithTableViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.citiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellIdentifier = @"PSCell";
    
    PSCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PSCell alloc] init];
    }
    
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    
    cell.index = indexPath.row;
    cell.cityName = [self.citiesArray objectAtIndex:indexPath.row];
    
    [cell.activityIndicator startAnimating];
    
    PSCityInfo *cityInfo = [[PSCityInfo alloc] init];
    [cityInfo loadDataForCell:cell];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL canEdit;
    
    if (indexPath.row == 0) {
        canEdit = NO;
    } else {
        canEdit = YES;
    }
    
    return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.myTableView beginUpdates];
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        [self.citiesArray removeObjectAtIndex:indexPath.row];
        [self.myTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        [self.myTableView endUpdates];
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL canMove;
    
    if (indexPath.row == 0) {
        canMove = NO;
    } else {
        canMove = YES;
    }
    
    return canMove;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (destinationIndexPath.row != 0) {
        NSString *string = [self.citiesArray objectAtIndex:sourceIndexPath.row];
        [self.citiesArray removeObject:[self.citiesArray objectAtIndex:sourceIndexPath.row]];
        [self.citiesArray insertObject:string atIndex:destinationIndexPath.row];
    }
    
    [self.myTableView reloadData];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.pageIndex = indexPath.row;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Actions

- (IBAction)openSearchViewController:(UIBarButtonItem *)sender {
    PSSearchViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"PSSearchViewController"];
    svc.citiesArray = self.citiesArray;
    [self presentViewController:svc animated:YES completion:nil];
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    
    BOOL isEditing = self.myTableView.editing;
    [self.myTableView setEditing:!isEditing animated:YES];
    
    if (self.myTableView.editing) {
        self.editBarButtonItem.title = @"Done";
    } else {
        self.editBarButtonItem.title = @"Edit";
    }

}

- (void)dealloc {
    NSLog(@"TABLE DEALLOCATED");
}

@end
