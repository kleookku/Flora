//
//  AddViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Board.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  AddViewControllerDelegate

- (void)updateBoard;

@end

@interface AddViewController : UIViewController

@property (nonatomic, strong)Board *board;
@property (nonatomic, strong)id<AddViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
