//
//  SelectViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectViewControllerDelegate

- (void)boardsSelected;

@end

@interface SelectViewController : UIViewController

@property (nonatomic, strong)NSString *plantId;
@property (nonatomic, strong)id<SelectViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
