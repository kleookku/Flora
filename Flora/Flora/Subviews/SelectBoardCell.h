//
//  SelectBoardCell.h
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectBoardCellDelegate

- (void)confirmAddToBoard:(UIAlertController *)confirmation;

- (void)updateBoards;

@end

@interface SelectBoardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIButton *addToBoardButton;
@property (weak, nonatomic) IBOutlet UILabel *boardName;

@property (nonatomic, strong)Board *board;
@property (nonatomic, strong)NSString *plantToAdd;
@property (nonatomic, strong) id<SelectBoardCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
