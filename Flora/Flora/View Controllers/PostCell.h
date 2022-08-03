//
//  PostCell.h
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate

- (void)plantPressed:(Plant *)plant;
- (void)profilePressed:(PFUser *)user;
- (void)showComments:(Post *)post;

@end


@interface PostCell : UITableViewCell

@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UIButton *plantButton;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionUsernameLabel;

@property (nonatomic, strong)id<PostCellDelegate> delegate;
@property (nonatomic, strong)Plant *plant;

@end

NS_ASSUME_NONNULL_END
