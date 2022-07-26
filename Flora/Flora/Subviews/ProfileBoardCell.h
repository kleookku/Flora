//
//  ProfileBoardCell.h
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Board.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileBoardCellDelegate

- (void)didTapBoard:(Board *)board;

@end

@interface ProfileBoardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *boardName;
@property (weak, nonatomic) IBOutlet UILabel *numPlants;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;

@property (nonatomic, strong) Board *board;
@property (nonatomic, strong) id<ProfileBoardCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
