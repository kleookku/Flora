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

@interface SearchViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong)NSArray *results;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moistureControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sunlightControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperaturecontrol;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (nonatomic, strong)NSString *moist;
@property (nonatomic, strong)NSString *shade;
@property (nonatomic, strong)NSNumber *minTemp;
@property (nonatomic, strong)NSNumber *maxTemp;
@property (nonatomic, strong)NSNumber *numResults;
@property (nonatomic) NSUInteger offset;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)MKPointAnnotation *annotation;
@property (nonatomic, strong)UIAlertController *locationAlert;
@property (nonatomic, strong)CLLocation *currentLocation;
@property (nonatomic, strong)NSString *state;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchButton.layer.cornerRadius = 10;
    self.offset = 0;
    self.map.layer.cornerRadius = 10;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.annotation = [[MKPointAnnotation alloc] init];
    
    [self setupAlerts];
}

#pragma mark - Alerts

- (void)setupAlerts{
    self.locationAlert = [UIAlertController alertControllerWithTitle:@"Use Current Location?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    [self.locationAlert addAction:noAction];
    [self.locationAlert addAction:yesAction];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(error)) {
            MKPlacemark *placemark = [placemarks objectAtIndex:0];
            self.state = placemark.administrativeArea;
            NSLog(@"state is %@", self.state);
            [self.annotation setCoordinate:self.currentLocation.coordinate];
            [self.map addAnnotation:self.annotation];
        } else
            NSLog(@"Geocode failed with error %@", error);
        }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {}
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {}


#pragma mark - Actions

- (IBAction)onTapSearch:(id)sender {
    [self.activityIndicator startAnimating];
    self.searchButton.enabled = NO;
    [self queryPlants];
}

- (IBAction)onTapLocation:(id)sender {
    [self presentViewController:self.locationAlert animated:YES completion:nil];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *resultsVC = [segue destinationViewController];
    resultsVC.plantsArray = [self.results mutableCopy];
}


@end
