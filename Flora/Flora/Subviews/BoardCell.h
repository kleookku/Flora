//
//  BoardCell.h
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Board.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BoardCellDelegate

- (void)didTapViewBoard:(Board *)board;

@end

@interface BoardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *boardName;
@property (weak, nonatomic) IBOutlet UILabel *numPlants;
@property (weak, nonatomic) IBOutlet PFImageView *coverImage;
@property (nonatomic, strong) id<BoardCellDelegate> delegate;
@property (nonatomic, strong)Board *board;

@end

NS_ASSUME_NONNULL_END
