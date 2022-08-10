//
//  ComposePlantCell.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "ComposePlantCell.h"

@implementation ComposePlantCell

- (IBAction)didSelect:(id)sender {
    if(self.isSelected) {
        self.isSelected = NO;
        [self.selectedButton setBackgroundColor:[UIColor clearColor]];
        [self.selectedButton setTintColor:[UIColor clearColor]];
        [self.delegate unselectedPlant:self.plant];
    } else if(!self.delegate.selectedPlant){
        self.isSelected = YES;
        [self.selectedButton setTintColor:[UIColor whiteColor]];
        [self.delegate selectedPlant:self.plant];
    } else {
        [self.delegate presentWarning];
    }
}
- (void)unselect {
    self.isSelected = NO;
    [self.selectedButton setHidden:YES];
}

- (void)setPlant:(Plant *)plant {
    _plant = plant;
    self.image.file = plant.image;
    [self.image loadInBackground];
    self.image.layer.cornerRadius = 20;
    
    self.name.text = plant.name;
}

@end
