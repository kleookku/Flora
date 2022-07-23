//
//  ResultsViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import "ResultsViewController.h"
#import "ZLSwipeableView/ZLSwipeableView.h"
#import "CardView.h"
#import "APIManager.h"
#import "DetailViewController.h"
#import "Parse/Parse.h"
#import "Plant.h"

#define PLANT_ID @"AcceptedId"
#define PLANT_IMAGE @"ProfileImageFilename"
#define PLANT_NAME @"CommonName"
 
@interface ResultsViewController () <CardViewDelegate>

@property (nonatomic) BOOL loadCardFromXib;

@property (nonatomic) NSUInteger plantIndex;
@property (nonatomic) NSUInteger offset;
@property BOOL NO_MORE_RESULTS;
@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)Plant *plantToDisplay;

@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.plantIndex = 0;
    self.offset = -1;
    self.user = [PFUser currentUser];

    // Required Data Source
    self.swipeableView.dataSource = self;

    // Optional Delegate
    self.swipeableView.delegate = self;

    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfHistoryItem = 3;
    
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController)
        [self reset];
}

- (void)reset {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    self.plantsArray = [[NSMutableArray alloc] init];
    self.plantIndex = 0;
    self.offset = -1;
}


#pragma mark - Action

- (IBAction)didTapDislike:(id)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)didTapLikebutton:(id)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (IBAction)didTapPreviousButton:(id)sender {
    self.plantIndex--;
    [self.swipeableView rewind];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    if(direction == ZLSwipeableViewDirectionLeft) {
        [self handleLeft:view];
    } else if (direction == ZLSwipeableViewDirectionRight) {
        [self handleRight:view];
    }
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if(!_NO_MORE_RESULTS){
        
        
        if(self.plantIndex < self.plantsArray.count) {
            CardView *view = [[CardView alloc] initWithPlant:swipeableView.bounds plant:_plantsArray[self.plantIndex]];
            view.delegate = self;
            view.backgroundColor = [UIColor whiteColor];
            self.plantIndex++;
            return view;
        }
        else {
            _NO_MORE_RESULTS = YES;
        }

    }
    return nil;
}

#pragma mark - CardViewDelegate

- (void)plantClicked:(Plant *)plant {
    self.plantToDisplay = plant;
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];
}


#pragma mark - Handlers

- (void)handleLeft:(UIView *)sender {
    CardView *plantView = (CardView *)sender;
    Plant *curPlant = plantView.plant;
    if(curPlant)
        [APIManager savePlantToSeen:curPlant];
}

- (void)handleRight:(UIView *)sender {
    CardView *plantView = (CardView *)sender;
    Plant *curPlant = plantView.plant;
    if(curPlant)
        [APIManager savePlantToLikes:curPlant];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.plant = self.plantToDisplay;
}


@end
