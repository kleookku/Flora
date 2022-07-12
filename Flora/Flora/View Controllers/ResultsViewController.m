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

#define PLANTS_PER_PAGE 25;
#define CARD_OFFSET = 4;
#define PLANT_ID @"AcceptedId"
#define PLANT_IMAGE @"ProfileImageFilename"
#define PLANT_NAME @"CommonName"
 
@interface ResultsViewController ()


@property (nonatomic) BOOL loadCardFromXib;

@property (nonatomic) NSUInteger plantIndex;
@property (nonatomic) NSUInteger offset;
@property BOOL NO_MORE_RESULTS;
@property (nonatomic, strong)PFUser *user;

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

    // Do any additional setup after loading the view, typically from a nib.

    // Required Data Source
    self.swipeableView.dataSource = self;

    // Optional Delegate
    self.swipeableView.delegate = self;

    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfHistoryItem = 3;
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

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController){
        [self reset];
    }
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}
#pragma mark - Action

- (IBAction)didTapDislike:(id)sender {
    [self.swipeableView swipeTopViewToLeft];
    [self handleLeft:sender];
}

- (IBAction)didTapLikebutton:(id)sender {
    [self.swipeableView swipeTopViewToRight];

    [self handleRight:sender];
}

- (IBAction)didTapPreviousButton:(id)sender {
    [self handlePrevious:sender];
    self.plantIndex = _plantIndex - 1;
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    if(direction == ZLSwipeableViewDirectionLeft) {
        [self handleLeft:nil];
    } else if (direction == ZLSwipeableViewDirectionRight) {
        [self handleRight:nil];
    }
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if(!_NO_MORE_RESULTS){
        if(self.plantIndex + 10 == self.plantsArray.count) {
            self.offset = _offset + PLANTS_PER_PAGE;
            [self createCharacteristicSearchWithOffset];
        }
        
        if(self.plantIndex < self.plantsArray.count) {
            CardView *view = [[CardView alloc] initWithPlant:swipeableView.bounds plantDict:_plantsArray[self.plantIndex]];
            self.plantIndex++;
            view.backgroundColor = [UIColor whiteColor];
            return view;
        } else if(self.plantIndex >= self.plantsArray.count) {
            CardView *view = [[CardView alloc] initWithLoad:swipeableView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            return view;
        }
    }
    return nil;
}


#pragma mark - Handlers

- (void)handleLeft:(UIButton *)sender {
    NSDictionary *curPlant = self.plantsArray[self.plantIndex-4];
    NSString *plantId = [NSString stringWithFormat:@"%@", curPlant[@"Id"]];
    
    // save plant id to user's seen
    NSMutableArray *seenArray = [[NSMutableArray alloc] initWithArray:self.user[@"seen"] copyItems:YES];
    [seenArray addObject:plantId];
    self.user[@"seen"] = seenArray;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Saved!");
        }
    }];
}

- (void)handleRight:(UIButton *)sender {    
    NSDictionary *curPlant = self.plantsArray[self.plantIndex-4];
    NSString *plantId = [NSString stringWithFormat:@"%@", curPlant[@"Id"]];
    
    // save plant PFObject to database
    [Plant savePlantWithDict:curPlant withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving plant: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved plant!");
        }
    }];

    
    // save plant to user's likes
    NSMutableArray *likesArray = [[NSMutableArray alloc] initWithArray:self.user[@"likes"] copyItems:YES];
    [likesArray addObject:plantId];
    self.user[@"likes"] = likesArray;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Saved!");
        }
    }];
    
}

- (void)handlePrevious:(UIBarButtonItem *)sender {
    [self.swipeableView rewind];
}

#pragma mark - Networking

- (void)createCharacteristicSearchWithOffset {
    [[APIManager shared] searchWithShadeLevel:self.shade withMoistureUse:self.moist withMinTemperature:self.temp offsetBy:self.offset completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
            if(results) {
                NSLog(@"Successfully created characteristics search!");
                if(results.count == 0){
                    self.NO_MORE_RESULTS = true;
                }
                [self.plantsArray addObjectsFromArray:results];
                
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
//    if( [sender isKindOfClass:[UIButton class]] ){
// 
//    }
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.plantDict = self.plantsArray[_plantIndex-4];
}


@end
