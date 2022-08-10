//
//  PlantCell.h
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "Parse/PFImageView.h"
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlantCellDelegate <NSObject>

- (void)deletePlantWithId:(NSString *)plantId;
- (void)presentConfirmationAlert:(UIAlertController *)alert;
- (void)presentPlantWithId:(Plant *)plant;

@end

@interface PlantCell : UICollectionViewCell <BoardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;

@property (nonatomic, strong)NSString *plantId;
@property (nonatomic, strong)id<PlantCellDelegate> delegate;
@property (nonatomic, strong)Plant *plant;

@end

NS_ASSUME_NONNULL_END
