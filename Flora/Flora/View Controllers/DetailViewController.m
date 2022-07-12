//
//  DetailViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import "DetailViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

#define PLANT_ID @"Id"
#define PLANT_NAME @"CommonName"
#define PLANT_IMAGE @"ProfileImageFilename"

#define LOW_SUN @"best in shady climates"
#define MID_SUN @"best in cloudy with sun climates"
#define HIGH_SUN @"best in sunny climates"
#define SUN_DICT @{@"Tolerant":LOW_SUN, @"Intermediate": MID_SUN, @"Intolerant": HIGH_SUN}

#define LOW_MOIST @"water every 2-3 weeks"
#define MED_MOIST @"water every 1-2 weeks"
#define HIGH_MOIST @"water every 3-4 days"
#define MOIST_ARRAY @[LOW_MOIST, MED_MOIST, HIGH_MOIST]
#define MOIST_DICT @{@"Low":LOW_MOIST, @"Medium": MED_MOIST, @"High": HIGH_MOIST}

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *plantImage;
@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet UILabel *moistLabel;
@property (weak, nonatomic) IBOutlet UILabel *shadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.plantName.text = self.plantDict[PLANT_NAME];
//    NSLog(@"plant dict is %@", self.plantDict);
    [self.plantImage setImageWithURL:[[APIManager shared] getPlantImageURL:self.plantDict[PLANT_IMAGE]]];
    self.activityIndicator.startAnimating;
    [self getPlantObj];
}

- (void)getPlantObj {
    NSString *idString = [NSString stringWithFormat:@"%@", self.plantDict[PLANT_ID]];
    [[APIManager shared] getPlantCharacteristicsWithId:idString completion:^(NSString * _Nonnull shade, NSString * _Nonnull moist, NSString * _Nonnull temp, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"Error reading plant characteristics: %@", error.localizedDescription);
        } else {
            self.activityIndicator.stopAnimating;
            self.moistLabel.text = MOIST_DICT[moist];
            self.shadeLabel.text = SUN_DICT[shade];
            self.tempLabel.text = [@"Minimum temperature is " stringByAppendingString:[temp stringByAppendingString:@"°F"]];
        }
    }];
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
