//
//  UserCell.h
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserCellDelegate

- (void)presentAlert:(UIAlertController *) alert;

- (void)removeUser:(NSString *)username fromSegment:(int)segment;

@end

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profPic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numBoards;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) id<UserCellDelegate> delegate;

@property BOOL isFollower;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UIAlertController *removeAlert;
@property (nonatomic, strong) UIAlertController *unfollowAlert;

@end

NS_ASSUME_NONNULL_END
