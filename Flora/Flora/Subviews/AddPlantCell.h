//
//  AddPlantCell.h
//  Flora
//
//  Created by Kleo Ku on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddPlantCellDelegate

- (void)addedPlant:(NSString *)plantId;
- (void)unaddedPlant:(NSString *)plantId;

@end

@interface AddPlantCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, strong) NSString *plantId;

@property BOOL added;
@property (nonatomic, strong)id<AddPlantCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
