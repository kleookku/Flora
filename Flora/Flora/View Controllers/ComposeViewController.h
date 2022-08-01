//
//  ComposeViewController.h
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didPost;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
