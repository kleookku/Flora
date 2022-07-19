//
//  SearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import "SearchViewController.h"
#import "APIManager.h"
#import "ResultsViewController.h"
#import "Parse/Parse.h"


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

#define NOT_LOW_TEMP @[@"-17 - -13", @"-12 - -8", @"-7 - -3", @"-2 - 2",@"3 - 7", @"8 - 13", @"13 - 17", @"18 - 22", @"23 - 27",@"28 - 32", @"33 - 37", @"38 - 42", @"43 - 47", @"48 - 52", @"53 - 57"]
#define NOT_MED_TEMP @[@"-75 - -53", @"-52 - -48", @"-47 - -43", @"-42 - -38", @"-37 - -33", @"-32 - -28", @"-27 - -23",@"-22 - -18", @"23 - 27",@"28 - 32", @"33 - 37", @"38 - 42", @"43 - 47", @"48 - 52", @"53 - 57"]
#define NOT_HIGH_TEMP @[@"-75 - -53", @"-52 - -48", @"-47 - -43", @"-42 - -38", @"-37 - -33", @"-32 - -28", @"-27 - -23",@"-22 - -18", @"-17 - -13", @"-12 - -8", @"-7 - -3", @"-2 - 2",@"3 - 7", @"8 - 13", @"13 - 17", @"18 - 22"]
#define NOT_TEMP_ARRAY @[NOT_LOW_TEMP, NOT_MED_TEMP, NOT_HIGH_TEMP]

#define PLANTS_PER_PAGE 25

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
@property (nonatomic) NSUInteger offset;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchButton.layer.cornerRadius = 10;
    self.offset = 0;
}
- (IBAction)onTapSearch:(id)sender {
    [self.activityIndicator startAnimating];
    self.searchButton.enabled = NO;

    [self queryPlants];
}

- (void)queryPlants {
    self.moist = MOIST_ARRAY[_moistureControl.selectedSegmentIndex];
    self.shade = SUN_ARRAY[_sunlightControl.selectedSegmentIndex];
    self.temp = NOT_TEMP_ARRAY[_temperaturecontrol.selectedSegmentIndex];

    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    
    [query whereKey:@"shadeLevel" equalTo:self.shade[0]];
    [query whereKey:@"moistureUse" equalTo:self.moist[0]];
    for(NSString *t in self.temp) {
        [query whereKey:@"minTemp" notEqualTo:t];
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
    for (NSUInteger i = 0; i < array.count - 1; ++i) {
        NSInteger remainingCount = array.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return mutableArray;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *resultsVC = [segue destinationViewController];
    resultsVC.plantsArray = [self.results mutableCopy];
    resultsVC.moist = self.moist;
    resultsVC.shade = self.shade;
    resultsVC.temp = self.temp;
    resultsVC.numResults = self.numResults;
}


@end
