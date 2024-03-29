//
//  DetailViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Plant.h"
#import "SelectViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerDelegate

- (void)likedPlant;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Plant *plant;
@property (nonatomic, strong)id<DetailViewControllerDelegate, SelectViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
