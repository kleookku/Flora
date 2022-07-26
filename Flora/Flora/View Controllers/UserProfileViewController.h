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
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet PFImageView *profPic;

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
