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

#define PLANTS_PER_PAGE 25;

@interface ResultsViewController ()


@property (nonatomic) BOOL loadCardFromXib;

@property (nonatomic) NSUInteger plantIndex;
@property (nonatomic) NSUInteger offset;
@property BOOL NO_MORE_RESULTS;

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
    
    // Do any additional setup after loading the view, typically from a nib.

    // Required Data Source
    self.swipeableView.dataSource = self;

    // Optional Delegate
    self.swipeableView.delegate = self;

    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfHistoryItem = [self.numResults unsignedIntegerValue]; //self.plantsArray.count;
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}
#pragma mark - Action

- (IBAction)didTapDislike:(id)sender {
    [self handleLeft:sender];
}
- (void)handleLeft:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)didTapLikebutton:(id)sender {
    [self handleRight:sender];
}
- (void)handleRight:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (IBAction)didTapPreviousButton:(id)sender {
    [self handlePrevious:sender];
}

- (void)handlePrevious:(UIBarButtonItem *)sender {
    [self.swipeableView rewind];
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if(!_NO_MORE_RESULTS){
        if(self.plantIndex + 25 == self.plantsArray.count) {
            self.offset = _offset + PLANTS_PER_PAGE;
            [self createCharacteristicSearchWithOffset];
        }
        
        if(self.plantIndex < self.plantsArray.count) {
            while(![self.plantsArray[self.plantIndex][@"ProfileImageFilename"] isKindOfClass:[NSString class]]) {
                self.plantIndex++;
            }
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
    if( [sender isKindOfClass:[UIButton class]] ){
        self.plantsArray[_plantIndex];
    }
}


@end
