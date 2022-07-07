//
//  ResultsViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import "ResultsViewController.h"
#import "ZLSwipeableView/ZLSwipeableView.h"
#import "CardView.h"

@interface ResultsViewController ()


@property (nonatomic) BOOL loadCardFromXib;

@property (nonatomic) NSUInteger plantIndex;

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
    
    // Do any additional setup after loading the view, typically from a nib.

    // Required Data Source
    self.swipeableView.dataSource = self;

    // Optional Delegate
    self.swipeableView.delegate = self;

    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfHistoryItem = self.plantsArray.count;
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

    // CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
    NSLog(@"plants are %@", self.plantsArray);
    
//    NSLog(@"image is %d", );
    if(self.plantIndex < self.plantsArray.count) {
        while(![_plantsArray[self.plantIndex][@"ProfileImageFilename"] isKindOfClass:[NSString class]]) {
            self.plantIndex++;
        }
        CardView *view = [[CardView alloc] initWithPlant:swipeableView.bounds
                                               plantDict:_plantsArray[self.plantIndex]];
        self.plantIndex++;
        view.backgroundColor = [UIColor blueColor];
        
        
        if (self.loadCardFromXib) {
            UIView *contentView =
                [[NSBundle mainBundle] loadNibNamed:@"CardContentView" owner:self options:nil][0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];

            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            NSDictionary *metrics =
                @{ @"height" : @(view.bounds.size.height),
                   @"width" : @(view.bounds.size.width) };
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
            [view addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                                         options:0
                                                         metrics:metrics
                                                           views:views]];
            [view addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|[contentView(height)]"
                                                         options:0
                                                         metrics:metrics
                                                           views:views]];
        }
        return view;
    }
    return nil;
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
