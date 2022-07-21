//
//  DetailViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerDelegate

- (void)likedPlant;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *plantDict;
@property (nonatomic, strong) Plant *plant;
@property (nonatomic, strong)id<DetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
