//
//  PostLikesCell.h
//  Flora
//
//  Created by Kleo Ku on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostLikesCellDelegate

- (void)tappedUserProfile:(PFUser *)user;


@end

@interface PostLikesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numBoards;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *profilebutton;

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) id<PostLikesCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
