//
//  UserSearchCell.h
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserSearchCellDelegate

- (void)unfollow:(NSString*) username;
- (void)follow:(NSString*) username;
- (void)tappedUserProfile:(PFUser *)user;


@end

@interface UserSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profPic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numBoards;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) PFUser* user;
@property (nonatomic, strong)id<UserSearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
