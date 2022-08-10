//
//  ProfileViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewControllerDelegate

- (void)updateInformation;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) id<ProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
