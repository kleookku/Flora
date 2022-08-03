//
//  NameSearchCell.h
//  Flora
//
//  Created by Kleo Ku on 7/28/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NameSearchCellDelegate <NSObject>

- (void)cellTapped:(Plant *)plant;

@end

@interface NameSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) Plant *plant;
@property (nonatomic, strong)id<NameSearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
