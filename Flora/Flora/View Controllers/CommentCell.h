//
//  CommentCell.h
//  Flora
//
//  Created by Kleo Ku on 8/3/22.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommentCellDelegate

- (void)displayProfile:(PFUser *)user;

@end

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;

@property (nonatomic, strong)Comment *comment;
@property (nonatomic, strong)id<CommentCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
