//
//  PlantCell.h
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlantCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UILabel *plantName;

@end

NS_ASSUME_NONNULL_END
