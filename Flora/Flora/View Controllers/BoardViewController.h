//
//  BoardViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "DetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BoardViewControllerDelegate

- (void)stoppedEdit;
- (void)tappedEdit;

@end

@interface BoardViewController : UIViewController

@property (nonatomic, strong)Board *board;
@property (nonatomic, strong)NSMutableArray<id<BoardViewControllerDelegate>> *cellDelegates;
@property (nonatomic, strong)id<BoardViewControllerDelegate, DetailViewControllerDelegate> delegate;
@property BOOL myBoard;

@end

NS_ASSUME_NONNULL_END
