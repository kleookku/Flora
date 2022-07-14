//
//  LikesViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LikesViewControllerDelegate

- (void)tappedEdit;
- (void)stoppedEdit;

@end

@interface LikesViewController : UIViewController

@property (nonatomic, strong)NSMutableArray<id<LikesViewControllerDelegate>> *delegates;


@end

NS_ASSUME_NONNULL_END
