//
//  AddPlantCell.m
//  Flora
//
//  Created by Kleo Ku on 7/15/22.
//

#import "AddPlantCell.h"

@implementation AddPlantCell
- (IBAction)didTappAdd:(id)sender {
    if(self.added) {
        self.added = NO;
        [self.addButton setImage:[UIImage systemImageNamed:@"plus.circle.fill"] forState:UIControlStateNormal];
        [self.delegate unaddedPlant:self.plantId];
    } else {
        self.added = YES;
        [self.addButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateNormal];
        [self.delegate addedPlant:self.plantId];
    }
}

@end
