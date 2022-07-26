//
//  DetailViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import "DetailViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "SelectViewController.h"
#import "Parse/PFImageView.h"

#define PLANT_ID @"Id"
#define PLANT_NAME @"CommonName"
#define PLANT_IMAGE @"ProfileImageFilename"

#define LOW_SUN @"Best in shady climates"
#define MID_SUN @"Best in cloudy with sun climates"
#define HIGH_SUN @"Best in sunny climates"
#define NO_SUN @"No sunlight information"
#define SUN_DICT @{@"Tolerant":LOW_SUN, @"Intermediate": MID_SUN, @"Intolerant": HIGH_SUN, @"N/A":NO_SUN}

#define LOW_MOIST @"Water every 2-3 weeks"
#define MED_MOIST @"Water every 1-2 weeks"
#define HIGH_MOIST @"Water every 3-4 days"
#define NO_MOIST @"No moisture information"
#define MOIST_DICT @{@"Low":LOW_MOIST, @"Medium": MED_MOIST, @"High": HIGH_MOIST, @"N/A": NO_MOIST}

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet UILabel *moistLabel;
@property (weak, nonatomic) IBOutlet UILabel *shadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UIButton *addToBoardButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.startAnimating;
    self.addToBoardButton.layer.cornerRadius = 15;
    [self getPlantObj];
}



- (void)getPlantObj {
    if(self.plant) {
        self.activityIndicator.stopAnimating;
        self.plantName.text = self.plant.name;
        self.plantImage.file = self.plant.image;
        [self.plantImage loadInBackground];
        self.moistLabel.text = MOIST_DICT[self.plant.moistureUse];
        self.shadeLabel.text = SUN_DICT[self.plant.shadeLevel];
        self.tempLabel.text = [@"Minimum temperature is " stringByAppendingString:[self.plant.minTemp stringByAppendingString:@"°F"]];
    } else {
        [self.plantImage setImageWithURL:[[APIManager shared] getPlantImageURL:self.plantDict[PLANT_IMAGE]]];
        self.plantName.text = self.plantDict[PLANT_NAME];
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
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(self.plant) {
        SelectViewController *selectVC = [segue destinationViewController];
        selectVC.plantId = self.plant.plantId;
        
    } else {
        SelectViewController *selectVC = [segue destinationViewController];
        selectVC.plantId = self.plantDict[PLANT_ID];
    }
}


@end
