//
//  BoardCell.h
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Board.h"
#import "LikesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BoardCellDelegate

- (void)didTapViewBoard:(Board *)board;
- (void)deleteBoard:(NSString *)boardName;
- (void)confirmBoardDelete:(UIAlertController *)alert;

@end

@interface BoardCell : UICollectionViewCell <LikesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *boardName;
@property (weak, nonatomic) IBOutlet UILabel *numPlants;
@property (weak, nonatomic) IBOutlet PFImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (nonatomic, strong) id<BoardCellDelegate> delegate;
@property (nonatomic, strong)Board *board;

@end

NS_ASSUME_NONNULL_END
