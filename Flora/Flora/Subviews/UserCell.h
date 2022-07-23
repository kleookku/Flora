//
//  UserCell.h
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profPic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numBoards;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property BOOL isFollower;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
