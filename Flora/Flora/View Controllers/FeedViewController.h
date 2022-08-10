//
//  FeedViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController

@property BOOL isPlantFeed;
@property (nonatomic, strong)Plant *plant;

@end

NS_ASSUME_NONNULL_END
