//
//  NameSearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/28/22.
//

#import "NameSearchViewController.h"
#import "Plant.h"
#import "Parse/PFImageView.h"
#import "Parse/Parse.h"
#import "NameSearchCell.h"
#import "DetailViewController.h"
#import "APIManager.h"

@interface NameSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, NameSearchCellDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) Plant *plantToShow;

@end

@implementation NameSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self updatePlants:@""];
}

- (void)updatePlants:(NSString *)searchText {
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    [query whereKey:@"name" containsString:searchText];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error searching plants" withMessage:error.localizedDescription] animated:YES completion:nil];
        } else {
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for(Plant *plant in objects){
                [results addObject:plant];
            }
            self.results = results;
            [self.tableView reloadData];
        }
    }];
}

# pragma mark - Actions

- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - NameSearchCellDelegate

- (void)cellTapped:(Plant *)plant {
    self.plantToShow = plant;
    [self performSegueWithIdentifier:@"NameSearchDetails" sender:nil];
}

# pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updatePlants:[searchText lowercaseString]];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NameSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameSearchCell"];
    cell.delegate = self;
    Plant *plant = _results[indexPath.row];
    cell.plant = plant;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.plant = self.plantToShow;
}


@end
