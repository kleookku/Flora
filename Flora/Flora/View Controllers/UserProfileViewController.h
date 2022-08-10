//
//  UserProfileViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;
@property BOOL notMyProfile;

@end

NS_ASSUME_NONNULL_END
