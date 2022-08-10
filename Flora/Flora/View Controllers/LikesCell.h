//
//  LikesCell.h
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import <UIKit/UIKit.h>
#import <Parse/PFImageView.h>
#import "Plant.h"
#import "LikesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LikesCellDelegate

- (void)didTapPlant:(Plant *) plant;
- (void)deletePlantFromLikes:(NSString *)plantId;
- (void)confirmLikeDelete:(UIAlertController *)alert;

@end

@interface LikesCell : UICollectionViewCell <LikesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *plantName;
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (nonatomic, strong) NSURL *plantUrl;
@property (nonatomic, strong) Plant *plant;
@property (nonatomic, strong) id<LikesCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
