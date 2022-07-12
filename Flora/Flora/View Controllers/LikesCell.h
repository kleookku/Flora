//
//  LikesCell.h
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikesCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (nonatomic, strong) NSURL *plantUrl;
@end

NS_ASSUME_NONNULL_END
