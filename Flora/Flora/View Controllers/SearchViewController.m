//
//  SearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import <CoreLocation/CoreLocation.h>
#import "SearchViewController.h"
#import "APIManager.h"
#import "ResultsViewController.h"
#import "Parse/Parse.h"
#import <MapKit/MapKit.h>

@import GooglePlaces;


#define LOW_SUN @"Tolerant"
#define MID_SUN @"Intermediate"
#define HIGH_SUN @"Intolerant"
#define NO_SUN @"Any"
#define SUN_ARRAY @[LOW_SUN, MID_SUN, HIGH_SUN, NO_SUN]

#define LOW_MOIST @"Low"
#define MED_MOIST @"Medium"
#define HIGH_MOIST @"High"
#define NO_MOIST @"Any"
#define MOIST_ARRAY @[LOW_MOIST, MED_MOIST, HIGH_MOIST, NO_MOIST]

#define MIN_TEMP_ARRAY @[@(-75), @(-17), @(23), @(0)]
#define MAX_TEMP_ARRAY @[@(-17), @(23), @(100), @(0)]


#define PLANTS_PER_PAGE 25

@interface SearchViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic, strong)NSArray *results;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moistureControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sunlightControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperaturecontrol;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *locationSearchButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong)NSString *moist;
@property (nonatomic, strong)NSString *shade;
@property (nonatomic, strong)NSNumber *minTemp;
@property (nonatomic, strong)NSNumber *maxTemp;

@property (nonatomic, strong)GMSAutocompleteFilter *filter;
@property (nonatomic, strong)NSString *lat;
@property (nonatomic, strong)NSString *lon;
@property (nonatomic, strong)UIAlertController *setLocationAlert;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchButton.layer.cornerRadius = 10;
    self.locationSearchButton.layer.cornerRadius = 10;
    
    self.setLocationAlert = [UIAlertController alertControllerWithTitle:@"Please set set location" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self.setLocationAlert addAction:okAction];
}


#pragma mark - Actions

- (IBAction)onTapSearch:(id)sender {
    [self.activityIndicator startAnimating];
    self.searchButton.enabled = NO;
    [self queryPlants];
}
- (IBAction)tappedUseLocation:(id)sender {
    // pull API Key from your new Keys.plist file
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *key = [dict objectForKey: @"googlePlace"];
    [GMSPlacesClient provideAPIKey:key];
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress);
    acController.placeFields = fields;
    
    _filter = [[GMSAutocompleteFilter alloc] init];
    _filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = _filter;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

- (IBAction)locationSegmentControl:(id)sender {
    if(self.locationControl.selectedSegmentIndex == 1) {
        if(_lat) {
            [self.moistureControl setUserInteractionEnabled:NO];
            [self.temperaturecontrol setUserInteractionEnabled:NO];
            [self.sunlightControl setUserInteractionEnabled:NO];
            [[APIManager shared] weatherValuesAtLat:self.lat atLong:self.lon withCompletion:^(int moist, int sun, int temp, NSError * _Nonnull error) {
                if(error) {
                    NSLog(@"Error getting weather values: %@", error.localizedDescription);
                } else {
                    NSLog(@"%i, %i, %i", moist, sun, temp);
                    self.moistureControl.selectedSegmentIndex = moist;
                    self.sunlightControl.selectedSegmentIndex = sun;
                    self.temperaturecontrol.selectedSegmentIndex = temp;
                }
            }];
            
        } else {
            [self presentViewController:self.setLocationAlert animated:YES completion:nil];
            self.locationControl.selectedSegmentIndex = 0;
        }
        
    } else {
        [self.moistureControl setUserInteractionEnabled:YES];
        [self.temperaturecontrol setUserInteractionEnabled:YES];
        [self.sunlightControl setUserInteractionEnabled:YES];
    }
}

#pragma mark - Do Search

- (void)queryPlants {
    self.moist = MOIST_ARRAY[_moistureControl.selectedSegmentIndex];
    self.shade = SUN_ARRAY[_sunlightControl.selectedSegmentIndex];
    self.minTemp = MIN_TEMP_ARRAY[_temperaturecontrol.selectedSegmentIndex];
    self.maxTemp = MAX_TEMP_ARRAY[_temperaturecontrol.selectedSegmentIndex];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    
    if(![self.moist isEqualToString:@"Any"])
        [query whereKey:@"moistureUse" equalTo:self.moist];
    if(![self.shade isEqualToString:@"Any"])
        [query whereKey:@"shadeLevel" equalTo:self.shade];
    if(![self.minTemp isEqualToValue:@(0)]) {
        [query whereKey:@"minTemp" greaterThan:self.minTemp];
        [query whereKey:@"minTemp" lessThan:self.maxTemp];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting search results: %@", error.localizedDescription);
        } else {
            self.results = [self shuffleArray:objects];
            [self.activityIndicator stopAnimating];
            self.searchButton.enabled = YES;
            [self performSegueWithIdentifier:@"searchSegue" sender:nil];
        }
    }];
}

- (NSArray *)shuffleArray:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [mutableArray addObjectsFromArray:array];
    if(array.count > 0) {
        for (NSUInteger i = 0; i < array.count - 1; ++i) {
            NSInteger remainingCount = array.count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
    }
    return mutableArray;
}

# pragma mark - GMSAutocompleteViewControllerDelegate

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
  [self dismissViewControllerAnimated:YES completion:nil];
  // Do something with the selected place.
    self.locationLabel.text = place.formattedAddress;
    NSLog(@"%f, %f", place.coordinate.latitude, place.coordinate.longitude);
    self.lat = [[NSNumber numberWithDouble:place.coordinate.latitude] stringValue];
    self.lon = [[NSNumber numberWithDouble:place.coordinate.longitude] stringValue];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

  // User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

  // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *resultsVC = [segue destinationViewController];
    resultsVC.plantsArray = [self.results mutableCopy];
}


@end
