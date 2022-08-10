//
//  ComposePlantCell.h
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Plant.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposePlantCellDelegate

@property (nonatomic, strong)Plant * _Nullable selectedPlant;

- (void) selectedPlant:(Plant *)plant;
- (void) unselectedPlant:(Plant *)plant;
- (void) presentWarning;

@end

@interface ComposePlantCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet PFImageView *image;

@property BOOL isSelected;
@property (nonatomic, strong) Plant *plant;
@property (nonatomic, strong)id<ComposePlantCellDelegate> delegate;

- (void)unselect;

@end

NS_ASSUME_NONNULL_END
