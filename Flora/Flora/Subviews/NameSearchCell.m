//
//  NameSearchCell.m
//  Flora
//
//  Created by Kleo Ku on 7/28/22.
//

#import "NameSearchCell.h"

@implementation NameSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setPlant:(Plant *)plant {
    _plant = plant;
    _image.file = plant.image;
    [_image loadInBackground];
    _name.text = plant.name;
}
- (IBAction)tappedPlant:(id)sender {
    [self.delegate cellTapped:self.plant];
}

@end
