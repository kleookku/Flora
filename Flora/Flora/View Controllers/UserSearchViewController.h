//
//  UserSearchViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserSearchViewControllerDelegate

- (void)updateTable;

@end

@interface UserSearchViewController : UIViewController

@property (nonatomic, strong)id<UserSearchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
