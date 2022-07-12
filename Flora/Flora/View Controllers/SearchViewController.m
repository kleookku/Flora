//
//  SearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import "SearchViewController.h"
#import "APIManager.h"
#import "ResultsViewController.h"


#define LOW_SUN @[@"Tolerant"]
#define MID_SUN @[@"Intermediate"]
#define HIGH_SUN @[@"Intolerant"]
#define SUN_ARRAY @[LOW_SUN, MID_SUN, HIGH_SUN]

#define LOW_MOIST @[@"Low"]
#define MED_MOIST @[@"Medium"]
#define HIGH_MOIST @[@"High"]
#define MOIST_ARRAY @[LOW_MOIST, MED_MOIST, HIGH_MOIST]


#define LOW_TEMP @[@"-75 - -53", @"-52 - -48", @"-47 - -43", @"-42 - -38", @"-37 - -33", @"-32 - -28", @"-27 - -23",@"-22 - -18"]
#define MED_TEMP @[@"-17 - -13", @"-12 - -8", @"-7 - -3", @"-2 - 2",@"3 - 7", @"8 - 13", @"13 - 17", @"18 - 22"]
#define HIGH_TEMP @[@"23 - 27",@"28 - 32", @"33 - 37", @"38 - 42", @"43 - 47", @"48 - 52", @"53 - 57"]
#define TEMP_ARRAY @[LOW_TEMP, MED_TEMP, HIGH_TEMP]

@interface SearchViewController ()

@property (nonatomic, strong)NSArray *results;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moistureControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sunlightControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperaturecontrol;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, strong)NSArray *moist;
@property (nonatomic, strong)NSArray *shade;
@property (nonatomic, strong)NSArray *temp;
@property (nonatomic, strong)NSNumber *numResults;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (IBAction)onTapSearch:(id)sender {
    self.activityIndicator.startAnimating;
    self.searchButton.enabled = NO;
    self.moist = MOIST_ARRAY[_moistureControl.selectedSegmentIndex];
    self.shade = SUN_ARRAY[_sunlightControl.selectedSegmentIndex];
    self.temp = TEMP_ARRAY[_temperaturecontrol.selectedSegmentIndex];
    
//    NSLog(@"moist: %@, shade: %@, temp: %@", self.moist, self.shade, self.temp);
    
    [self createCharacteristicSearchWithMoistureLevel:self.moist shadeLevel:self.shade minimumTemperature:self.temp];
}

- (void)createCharacteristicSearchWithMoistureLevel:(NSArray *)moisture shadeLevel:(NSArray *)shade  minimumTemperature:(NSArray *)temp {
    self.results = @[];
    [[APIManager shared] searchWithShadeLevel:shade withMoistureUse:moisture withMinTemperature:temp offsetBy:0 completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
            if(results) {
                NSLog(@"Successfully created characteristics search!");
//                NSLog(@"api results first item %@", results[0]);
                self.results = results;
//                NSLog(@"results first item %@", self.results[0]);
                self.activityIndicator.stopAnimating;
                self.searchButton.enabled = YES;
                
                [self performSegueWithIdentifier:@"searchSegue" sender:nil];
            } else {
                NSLog(@"Error creating characteristics search: %@", error.localizedDescription);
            }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ResultsViewController *resultsVC = [segue destinationViewController];
    resultsVC.plantsArray = [self.results mutableCopy];
    resultsVC.moist = self.moist;
    resultsVC.shade = self.shade;
    resultsVC.temp = self.temp;
    resultsVC.numResults = self.numResults;
}


@end
