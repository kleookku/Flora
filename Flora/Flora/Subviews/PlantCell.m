//
//  PlantCell.m
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import "PlantCell.h"

@implementation PlantCell
- (void)tappedEdit {
    self.deleteButton.contentMode = UIViewContentModeScaleAspectFill;
    self.deleteButton.layer.masksToBounds = false;
    self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.width/2;
    [self.deleteButton setHidden:NO];
}

- (void)stoppedEdit {
    [self.deleteButton setHidden:YES];
}

- (IBAction)didTapDelete:(id)sender {
    
    NSString *title = [[NSString alloc] initWithFormat:@"Remove \"%@\" from board?", self.plantName.text];
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deletePlantWithId:self.plantId];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [confirmationAlert addAction:cancelAction];
    [confirmationAlert addAction:confirmAction];
    [confirmationAlert setPreferredAction:cancelAction];
    
    [self.delegate presentConfirmationAlert:confirmationAlert];
}

@end
