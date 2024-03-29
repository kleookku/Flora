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
#import "FeedViewController.h"

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

#define ADD_TO_BOARD_BUTTON 1

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet UILabel *moistLabel;
@property (weak, nonatomic) IBOutlet UILabel *shadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *addToBoardButton;

@property (nonatomic, strong)CABasicAnimation *likeAnimation;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    self.addToBoardButton.layer.cornerRadius = 15;
    self.addToBoardButton.tag = ADD_TO_BOARD_BUTTON;
    [self updatePlantObj];
    
    _likeAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    _likeAnimation.duration=0.15;
    _likeAnimation.autoreverses=YES;
    _likeAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    _likeAnimation.toValue=[NSNumber numberWithFloat:0.5];
    _likeAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
}


- (void)updatePlantObj {
    if(self.plant) {
        [self.activityIndicator stopAnimating];
        self.plantName.text = self.plant.name;
        self.plantImage.file = self.plant.image;
        [self.plantImage loadInBackground];
        self.moistLabel.text = MOIST_DICT[self.plant.moistureUse];
        self.shadeLabel.text = SUN_DICT[self.plant.shadeLevel];
        NSString *minTempString = [self.plant.minTemp stringValue];
        self.tempLabel.text = [@"Minimum temperature is " stringByAppendingString:[minTempString stringByAppendingString:@"°F"]];
        
        NSArray *userLikes = [PFUser currentUser][@"likes"];
        if ([userLikes containsObject:self.plant.plantId]) {
            [self.likeButton setImage:[UIImage systemImageNamed:@"suit.heart.fill"] forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage systemImageNamed:@"suit.heart"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Actions

- (IBAction)didTapLike:(id)sender {
    [self.likeButton.layer addAnimation:self.likeAnimation forKey:@"animateOpacity"];

    NSArray *userLikes = [PFUser currentUser][@"likes"];
    if ([userLikes containsObject:self.plant.plantId]) {
        [APIManager removePlantFromLikes:self.plant];
        [self.likeButton setImage:[UIImage systemImageNamed:@"suit.heart"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor darkGrayColor]];
    } else {
        [APIManager savePlantToLikes:self.plant];
        [self.likeButton setImage:[UIImage systemImageNamed:@"suit.heart.fill"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor redColor]];
    }
    [self.delegate likedPlant];
}

- (IBAction)didTapOtherImages:(id)sender {
    [self performSegueWithIdentifier:@"PlantToFeed" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender tag] == 1) {
        SelectViewController *selectVC = [segue destinationViewController];
        selectVC.plantId = self.plant.plantId;
        selectVC.delegate = self.delegate;
    } else {
        FeedViewController *feedVC = [segue destinationViewController];
        feedVC.isPlantFeed = YES;
        feedVC.plant = self.plant;
    }
}


@end
