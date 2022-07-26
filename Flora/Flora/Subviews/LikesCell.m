//
//  LikesCell.m
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import "LikesCell.h"
#import "LikesViewController.h"

@implementation LikesCell 

- (IBAction)didTapPlant:(id)sender {
    [self.delegate didTapPlant:self.plant];
}

- (void) tappedEdit {
    self.deleteButton.contentMode = UIViewContentModeScaleAspectFill;
    self.deleteButton.layer.masksToBounds = false;
    self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.width/2;
    [self.deleteButton setHidden:NO];
    [self.detailsButton setUserInteractionEnabled:NO];
}

- (void) stoppedEdit {
    [self.deleteButton setHidden:YES];
    [self.detailsButton setUserInteractionEnabled:YES];
}

- (IBAction)didTapDelete:(id)sender {
    NSString *title = [[NSString alloc] initWithFormat:@"Delete \"%@\" from likes?", self.plant.name];
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deletePlantFromLikes:self.plant.plantId];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
     
    [confirmationAlert addAction:cancelAction];
    [confirmationAlert addAction:confirmAction];
    [confirmationAlert setPreferredAction:cancelAction];
    [self.delegate confirmLikeDelete:confirmationAlert];
}


@end
