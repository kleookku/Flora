//
//  PostGridCell.h
//  Flora
//
//  Created by Kleo Ku on 8/1/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostGridCellDelegate

- (void)didTapPost:(Post *)post;

@end

@interface PostGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (nonatomic, strong)Post *post;
@property (nonatomic, strong)id<PostGridCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
