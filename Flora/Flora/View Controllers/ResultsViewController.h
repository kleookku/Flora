//
//  ResultsViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultsViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong)NSArray *plantsArray;


- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;

@end

NS_ASSUME_NONNULL_END
