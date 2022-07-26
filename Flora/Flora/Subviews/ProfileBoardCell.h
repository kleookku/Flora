//
//  ProfileBoardCell.h
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileBoardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *boardName;
@property (weak, nonatomic) IBOutlet UILabel *numPlants;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;

@end

NS_ASSUME_NONNULL_END
